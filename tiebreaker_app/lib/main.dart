import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const TiebreakerApp());
}

class TiebreakerApp extends StatelessWidget {
  const TiebreakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI TIEBREAKER APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TiebreakerHome(),
    );
  }
}

class TiebreakerHome extends StatefulWidget {
  const TiebreakerHome({super.key});

  @override
  State<TiebreakerHome> createState() => _TiebreakerHomeState();
}

class _TiebreakerHomeState extends State<TiebreakerHome> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  String _prosCons = "";
  String _comparison = "";
  String _swot = "";
  String _verdict = "";

  final String _apiKey = 'AIzaSyBfeInVryQ2XnDR0h8adYTGVsQM78KN0k0';

  Future<void> _analyzeScenario() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _prosCons = ""; _comparison = ""; _swot = ""; _verdict = "";
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash', // Fixed model version
        apiKey: _apiKey,
      );

      final prompt = '''
      Act as a professional decision-making consultant. Scenario: "$input"
      
      Provide a "Tiebreaker Report" split exactly by these markers [SECTION_1], [SECTION_2], [SECTION_3], [SECTION_4].
      
      [SECTION_1]
      ## Pros & Cons
      (List advantages/disadvantages)

      [SECTION_2]
      ## Comparison Table
      | Factor | Option A | Option B |
      | :--- | :--- | :--- |

      [SECTION_3]
      ## SWOT Analysis
      | Category | Details |
      | :--- | :--- |
      | **Strengths** | ... |
      | **Weaknesses** | ... |
      | **Opportunities** | ... |
      | **Threats** | ... |

      [SECTION_4]
      ## Final Verdict
      (Conclusion)
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final text = response.text ?? "";

      if (text.contains("[SECTION_1]")) {
        final parts = text.split(RegExp(r'\[SECTION_\d\]'));
        setState(() {
          _prosCons = parts.length > 1 ? parts[1].trim() : "";
          _comparison = parts.length > 2 ? parts[2].trim() : "";
          _swot = parts.length > 3 ? parts[3].trim() : "";
          _verdict = parts.length > 4 ? parts[4].trim() : "";
        });
      }
    } catch (e) {
      setState(() { _prosCons = "### ⚠️ Error\n$e"; });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('⚖️ AI Tiebreaker App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputCard(colorScheme),
            const SizedBox(height: 16),
            if (_isLoading) const LinearProgressIndicator(),

            // Result Section
            if (_prosCons.isNotEmpty) ...[
              Expanded(
                child: SingleChildScrollView( // Entire results area scrolls as one
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildColumnSection(_prosCons),
                          const VerticalDivider(width: 1),
                          _buildColumnSection(_comparison),
                          const VerticalDivider(width: 1),
                          _buildColumnSection(_swot),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildVerdictArea(colorScheme),
                    ],
                  ),
                ),
              ),
            ] else if (!_isLoading)
              const Expanded(child: Center(child: Text("Enter a dilemma to start analysis."))),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 2,
              decoration: const InputDecoration(hintText: 'Describe your decision...', border: InputBorder.none),
            ),
            const Divider(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _analyzeScenario,
                icon: const Icon(Icons.bolt),
                label: const Text('Break the Tie'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Changed from Markdown to MarkdownBody to prevent individual scrolling
  Widget _buildColumnSection(String data) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MarkdownBody(
          data: data,
          styleSheet: MarkdownStyleSheet(
            h2: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo),
            p: const TextStyle(fontSize: 12),
            tableBody: const TextStyle(fontSize: 11),
            tableBorder: TableBorder.all(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildVerdictArea(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MarkdownBody(
        data: _verdict,
        styleSheet: MarkdownStyleSheet(
          h2: TextStyle(color: colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}