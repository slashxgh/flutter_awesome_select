import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';

/// Example demonstrating SmartSelectFormField with async data loading
/// and Form validation on submit.
class FeaturesFormFieldAsync extends StatefulWidget {
  @override
  _FeaturesFormFieldAsyncState createState() => _FeaturesFormFieldAsyncState();
}

class _FeaturesFormFieldAsyncState extends State<FeaturesFormFieldAsync> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Selected values
  String? _selectedCountry;
  List<String> _selectedLanguages = [];

  // Async loaded data
  List<S2Choice<String>> _countries = [];
  List<S2Choice<String>> _languages = [];

  // Loading states
  bool _isLoadingCountries = true;
  bool _isLoadingLanguages = true;

  // Form submission state
  bool _isSubmitting = false;
  String? _submissionResult;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Simulates async API calls to fetch data
  Future<void> _loadData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate fetching countries from an API
    final countriesData = [
      {'code': 'us', 'name': 'United States'},
      {'code': 'uk', 'name': 'United Kingdom'},
      {'code': 'ca', 'name': 'Canada'},
      {'code': 'au', 'name': 'Australia'},
      {'code': 'de', 'name': 'Germany'},
      {'code': 'fr', 'name': 'France'},
      {'code': 'jp', 'name': 'Japan'},
      {'code': 'kr', 'name': 'South Korea'},
      {'code': 'br', 'name': 'Brazil'},
      {'code': 'in', 'name': 'India'},
    ];

    setState(() {
      _countries = S2Choice.listFrom<String, Map<String, String>>(
        source: countriesData,
        value: (index, item) => item['code']!,
        title: (index, item) => item['name']!,
      );
      _isLoadingCountries = false;
    });

    // Simulate another API call for languages
    await Future.delayed(const Duration(milliseconds: 500));

    final languagesData = [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'zh', 'name': 'Chinese'},
      {'code': 'ja', 'name': 'Japanese'},
      {'code': 'ko', 'name': 'Korean'},
      {'code': 'pt', 'name': 'Portuguese'},
      {'code': 'ar', 'name': 'Arabic'},
      {'code': 'hi', 'name': 'Hindi'},
    ];

    setState(() {
      _languages = S2Choice.listFrom<String, Map<String, String>>(
        source: languagesData,
        value: (index, item) => item['code']!,
        title: (index, item) => item['name']!,
      );
      _isLoadingLanguages = false;
    });
  }

  /// Handles form submission
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
        _submissionResult = null;
      });

      // Simulate API submission
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isSubmitting = false;
        _submissionResult =
            'Form submitted!\nCountry: $_selectedCountry\nLanguages: ${_selectedLanguages.join(", ")}';
      });
    }
  }

  /// Resets the form
  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedCountry = null;
      _selectedLanguages = [];
      _submissionResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Field with Async Loading'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Description card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SmartSelectFormField Example',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This example demonstrates:\n'
                        '• Async data loading on screen load\n'
                        '• Form validation on submit\n'
                        '• Single and multiple selection\n'
                        '• Custom error styling',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Single selection with async loading
              Text(
                'Select Your Country',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_isLoadingCountries)
                const Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    title: Text('Loading countries...'),
                  ),
                )
              else
                SmartSelectFormField<String>.single(
                  title: 'Country',
                  placeholder: 'Select your country',
                  selectedValue: _selectedCountry,
                  choiceItems: _countries,
                  modalType: S2ModalType.bottomSheet,
                  modalFilter: true,
                  modalFilterHint: 'Search countries...',
                  onChange: (selected) {
                    setState(() => _selectedCountry = selected.value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedCountry = value;
                  },
                  errorConfig: SmartSelectFormFieldErrorConfig(
                    errorStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    errorPadding: const EdgeInsets.only(top: 8, left: 16),
                  ),
                  useInputDecorator: false,
                  tileBuilder: (context, state) {
                    return Card(
                      child: S2Tile.fromState(
                        state,
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        leading: const Icon(Icons.public),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),

              // Multiple selection with async loading
              Text(
                'Select Languages You Speak',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (_isLoadingLanguages)
                const Card(
                  child: ListTile(
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    title: Text('Loading languages...'),
                  ),
                )
              else
                SmartSelectMultipleFormField<String>(
                  title: 'Languages',
                  placeholder: 'Select languages',
                  selectedValue: _selectedLanguages,
                  choiceItems: _languages,
                  modalType: S2ModalType.bottomSheet,
                  modalConfirm: true,
                  modalFilter: true,
                  modalFilterHint: 'Search languages...',
                  choiceType: S2ChoiceType.checkboxes,
                  onChange: (selected) {
                    setState(() => _selectedLanguages = selected.value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select at least one language';
                    }
                    if (value.length > 5) {
                      return 'Maximum 5 languages allowed';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedLanguages = value ?? [];
                  },
                  errorConfig: SmartSelectFormFieldErrorConfig(
                    errorBuilder: (context, errorText) {
                      return Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .errorContainer
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 18,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorText ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  useInputDecorator: false,
                  tileBuilder: (context, state) {
                    return Card(
                      child: S2Tile.fromState(
                        state,
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        leading: const Icon(Icons.language),
                        body: state.selected.length > 0
                            ? S2TileChips(
                                chipLength: state.selected.length,
                                chipLabelBuilder: (context, i) {
                                  return Text(
                                      state.selected.choice?[i].title ?? '');
                                },
                                chipColor: Theme.of(context).primaryColor,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 32),

              // Submit and Reset buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : _resetForm,
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Submit'),
                    ),
                  ),
                ],
              ),

              // Submission result
              if (_submissionResult != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'Success!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_submissionResult!),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
