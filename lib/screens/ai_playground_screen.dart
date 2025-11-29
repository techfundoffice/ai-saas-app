import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/ai_provider.dart';

class AIPlaygroundScreen extends StatefulWidget {
  const AIPlaygroundScreen({super.key});

  @override
  State<AIPlaygroundScreen> createState() => _AIPlaygroundScreenState();
}

class _AIPlaygroundScreenState extends State<AIPlaygroundScreen> {
  final _textController = TextEditingController();
  String _selectedMode = 'text';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processRequest() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a prompt'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final subProvider = context.read<SubscriptionProvider>();
    final aiProvider = context.read<AIProvider>();

    // Calculate credit cost
    final creditCost = aiProvider.calculateCreditCost(
      _selectedMode == 'text' ? 'text_generation' : 'image_generation',
    );

    // Check if user has enough credits
    if (subProvider.credits < creditCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient credits. Need $creditCost credits.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Buy Credits',
            onPressed: () {
              Navigator.of(context).pushNamed('/subscription');
            },
          ),
        ),
      );
      return;
    }

    // Deduct credits
    final success = await subProvider.useCredits(
      userId: authProvider.user!.id,
      amount: creditCost,
      purpose: _selectedMode == 'text' ? 'text_generation' : 'image_generation',
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to process request'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Process AI request
    if (_selectedMode == 'text') {
      await aiProvider.generateText(prompt: _textController.text.trim());
    } else {
      await aiProvider.generateImage(prompt: _textController.text.trim());
    }

    if (aiProvider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${aiProvider.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Playground'),
        actions: [
          Consumer<SubscriptionProvider>(
            builder: (context, subProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Chip(
                    avatar: const Icon(Icons.stars, size: 16),
                    label: Text('${subProvider.credits} credits'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'text',
                          label: Text('Text Generation'),
                          icon: Icon(Icons.text_fields),
                        ),
                        ButtonSegment(
                          value: 'image',
                          label: Text('Image Generation'),
                          icon: Icon(Icons.image),
                        ),
                      ],
                      selected: {_selectedMode},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedMode = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Your Prompt',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _textController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: _selectedMode == 'text'
                            ? 'e.g., Write a short story about...'
                            : 'e.g., A futuristic city at sunset...',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<AIProvider>(
                      builder: (context, aiProvider, child) {
                        final creditCost = aiProvider.calculateCreditCost(
                          _selectedMode == 'text' ? 'text_generation' : 'image_generation',
                        );
                        
                        return SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: aiProvider.isProcessing ? null : _processRequest,
                            icon: aiProvider.isProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                              aiProvider.isProcessing
                                  ? 'Processing...'
                                  : 'Generate ($creditCost credits)',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<AIProvider>(
              builder: (context, aiProvider, child) {
                if (aiProvider.isProcessing) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (_selectedMode == 'text' && aiProvider.lastResult != null) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Result',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  // TODO: Copy to clipboard
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(aiProvider.lastResult!),
                        ],
                      ),
                    ),
                  );
                }

                if (_selectedMode == 'image' && aiProvider.lastImageUrl != null) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generated Image',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              aiProvider.lastImageUrl!,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
