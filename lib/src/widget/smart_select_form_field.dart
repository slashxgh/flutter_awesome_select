import 'package:flutter/material.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';

/// Typedef for building a custom error widget
typedef SmartSelectFormFieldErrorBuilder = Widget Function(
  BuildContext context,
  String? errorText,
);

/// Typedef for building a custom wrapper around the SmartSelect widget
typedef SmartSelectFormFieldWrapperBuilder<T> = Widget Function(
  BuildContext context,
  Widget child,
  FormFieldState<T> state,
);

/// Configuration class for customizing the FormField error display
class SmartSelectFormFieldErrorConfig {
  /// The style to apply to the error text
  final TextStyle? errorStyle;

  /// Padding around the error text
  final EdgeInsetsGeometry? errorPadding;

  /// Maximum number of lines for the error text
  final int? errorMaxLines;

  /// Whether to show the error text below (true) or above (false) the widget
  final bool errorBelowField;

  /// Custom builder for the error widget
  final SmartSelectFormFieldErrorBuilder? errorBuilder;

  const SmartSelectFormFieldErrorConfig({
    this.errorStyle,
    this.errorPadding,
    this.errorMaxLines,
    this.errorBelowField = true,
    this.errorBuilder,
  });
}

/// A [FormField] that wraps a [SmartSelect.single] widget.
///
/// This widget allows you to use [SmartSelect.single] within a [Form] and
/// benefit from form validation, save, and reset functionality.
///
/// Example:
/// ```dart
/// SmartSelectFormField<String>.single(
///   title: 'Framework',
///   selectedValue: _framework,
///   choiceItems: S2Choice.listFrom<String, Map>(
///     source: frameworks,
///     value: (index, item) => item['value'],
///     title: (index, item) => item['title'],
///   ),
///   validator: (value) {
///     if (value == null) {
///       return 'Please select a framework';
///     }
///     return null;
///   },
///   onSaved: (value) {
///     _framework = value;
///   },
///   // Custom error display
///   errorConfig: SmartSelectFormFieldErrorConfig(
///     errorStyle: TextStyle(color: Colors.red, fontSize: 12),
///     errorPadding: EdgeInsets.only(top: 8),
///   ),
/// )
/// ```
class SmartSelectFormField<T> extends FormField<T> {
  /// Creates a [FormField] that wraps a [SmartSelect.single] widget.
  SmartSelectFormField.single({
    super.key,

    // FormField parameters
    super.onSaved,
    super.validator,
    super.restorationId,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,

    // SmartSelect parameters
    String? title,
    String placeholder = 'Select one',
    required T? selectedValue,
    S2Choice<T>? selectedChoice,
    S2SingleSelectedResolver<T>? selectedResolver,
    ValueChanged<S2SingleSelected<T>>? onChange,
    S2ChoiceSelect<S2SingleState<T>, S2Choice<T>>? onSelect,
    S2ModalOpen<S2SingleState<T>>? onModalOpen,
    S2ModalClose<S2SingleState<T>>? onModalClose,
    S2ModalWillOpen<S2SingleState<T>>? onModalWillOpen,
    S2ModalWillClose<S2SingleState<T>>? onModalWillClose,
    S2Validation<S2SingleChosen<T>>? validation,
    S2Validation<S2SingleChosen<T>>? modalValidation,
    List<S2Choice<T>>? choiceItems,
    S2ChoiceLoader<T>? choiceLoader,
    S2SingleBuilder<T>? builder,
    S2WidgetBuilder<S2SingleState<T>>? tileBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalHeaderBuilder,
    S2ListWidgetBuilder<S2SingleState<T>>? modalActionsBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalConfirmBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalDividerBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalFooterBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalFilterBuilder,
    S2WidgetBuilder<S2SingleState<T>>? modalFilterToggleBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Choice<T>>? choiceBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Choice<T>>? choiceTitleBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Choice<T>>? choiceSubtitleBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Choice<T>>? choiceSecondaryBuilder,
    IndexedWidgetBuilder? choiceDividerBuilder,
    S2WidgetBuilder<S2SingleState<T>>? choiceEmptyBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Group<T>>? groupBuilder,
    S2ComplexWidgetBuilder<S2SingleState<T>, S2Group<T>>? groupHeaderBuilder,
    S2ChoiceConfig? choiceConfig,
    S2ChoiceStyle? choiceStyle,
    S2ChoiceStyle? choiceActiveStyle,
    S2ChoiceType? choiceType,
    S2ChoiceLayout? choiceLayout,
    Axis? choiceDirection,
    bool? choiceGrouped,
    bool? choiceDivider,
    SliverGridDelegate? choiceGrid,
    int? choiceGridCount,
    double? choiceGridSpacing,
    int? choicePageLimit,
    Duration? choiceDelay,
    bool? choiceShrinkWrap,
    S2GroupConfig? groupConfig,
    bool? groupEnabled,
    bool? groupSelector,
    bool? groupCounter,
    S2GroupSort? groupSortBy,
    S2GroupHeaderStyle? groupHeaderStyle,
    S2ModalConfig? modalConfig,
    S2ModalStyle? modalStyle,
    S2ModalHeaderStyle? modalHeaderStyle,
    S2ModalType? modalType,
    String? modalTitle,
    bool? modalConfirm,
    bool? modalHeader,
    bool? modalFilter,
    bool? modalFilterAuto,
    String? modalFilterHint,
    AnimationStyle? modelAnimationStyle,

    // FormField customization
    /// Whether the field is enabled
    bool enabled = true,

    /// InputDecoration for the field (used when useInputDecorator is true)
    InputDecoration? decoration,

    /// Whether to use InputDecorator wrapper (default: true)
    /// Set to false for completely custom error display
    bool useInputDecorator = true,

    /// Configuration for error display customization
    SmartSelectFormFieldErrorConfig? errorConfig,

    /// Custom wrapper builder for complete control over the field layout
    SmartSelectFormFieldWrapperBuilder<T>? wrapperBuilder,
  }) : super(
          enabled: enabled,
          initialValue: selectedValue,
          builder: (FormFieldState<T> state) {
            final _SmartSelectFormFieldState<T> fieldState =
                state as _SmartSelectFormFieldState<T>;

            // Build the SmartSelect widget
            final smartSelectWidget = SmartSelect<T>.single(
                key: fieldState._smartSelectKey,
                title: title,
                placeholder: placeholder,
                selectedValue: fieldState.value as T,
                selectedChoice: selectedChoice,
                selectedResolver: selectedResolver,
                onChange: (S2SingleSelected<T> selected) {
                  fieldState.didChange(selected.value);
                  onChange?.call(selected);
                },
                onSelect: onSelect,
                onModalOpen: onModalOpen,
                onModalClose: onModalClose,
                onModalWillOpen: onModalWillOpen,
                onModalWillClose: onModalWillClose,
                validation: validation,
                modalValidation: modalValidation,
                choiceItems: choiceItems,
                choiceLoader: choiceLoader,
                builder: builder,
                tileBuilder: tileBuilder,
                modalBuilder: modalBuilder,
                modalHeaderBuilder: modalHeaderBuilder,
                modalActionsBuilder: modalActionsBuilder,
                modalConfirmBuilder: modalConfirmBuilder,
                modalDividerBuilder: modalDividerBuilder,
                modalFooterBuilder: modalFooterBuilder,
                modalFilterBuilder: modalFilterBuilder,
                modalFilterToggleBuilder: modalFilterToggleBuilder,
                choiceBuilder: choiceBuilder,
                choiceTitleBuilder: choiceTitleBuilder,
                choiceSubtitleBuilder: choiceSubtitleBuilder,
                choiceSecondaryBuilder: choiceSecondaryBuilder,
                choiceDividerBuilder: choiceDividerBuilder,
                choiceEmptyBuilder: choiceEmptyBuilder,
                groupBuilder: groupBuilder,
                groupHeaderBuilder: groupHeaderBuilder,
                choiceConfig: choiceConfig,
                choiceStyle: choiceStyle,
                choiceActiveStyle: choiceActiveStyle,
                choiceType: choiceType,
                choiceLayout: choiceLayout,
                choiceDirection: choiceDirection,
                choiceGrouped: choiceGrouped,
                choiceDivider: choiceDivider,
                choiceGrid: choiceGrid,
                choiceGridCount: choiceGridCount,
                choiceGridSpacing: choiceGridSpacing,
                choicePageLimit: choicePageLimit,
                choiceDelay: choiceDelay,
                choiceShrinkWrap: choiceShrinkWrap,
                groupConfig: groupConfig,
                groupEnabled: groupEnabled,
                groupSelector: groupSelector,
                groupCounter: groupCounter,
                groupSortBy: groupSortBy,
                groupHeaderStyle: groupHeaderStyle,
                modalConfig: modalConfig,
                modalStyle: modalStyle,
                modalHeaderStyle: modalHeaderStyle,
                modalType: modalType,
                modalTitle: modalTitle,
                modalConfirm: modalConfirm,
                modalHeader: modalHeader,
                modalFilter: modalFilter,
                modalFilterAuto: modalFilterAuto,
                modalFilterHint: modalFilterHint,
                modelAnimationStyle: modelAnimationStyle,
              );

            // If custom wrapper builder is provided, use it
            if (wrapperBuilder != null) {
              return wrapperBuilder(state.context, smartSelectWidget, state);
            }

            // Use InputDecorator if enabled
            if (useInputDecorator) {
              final theme = Theme.of(state.context);

              // Extract borderRadius from caller's decoration or use default
              final callerBorder = decoration?.border;
              final borderRadius = callerBorder is OutlineInputBorder
                  ? callerBorder.borderRadius
                  : BorderRadius.circular(8);

              // Build all border variants with consistent borderRadius
              final normalBorder = callerBorder is OutlineInputBorder
                  ? callerBorder
                  : OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: theme.dividerColor,
                        width: 1.0,
                      ),
                    );

              final errorBorderStyle = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.5,
                ),
              );

              final InputDecoration effectiveDecoration = (decoration ??
                      const InputDecoration())
                  .applyDefaults(theme.inputDecorationTheme);

              // Explicitly set ALL border types to prevent theme overrides
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: fieldState.errorText,
                  border: normalBorder,
                  enabledBorder: normalBorder,
                  focusedBorder: normalBorder,
                  errorBorder: errorBorderStyle,
                  focusedErrorBorder: errorBorderStyle,
                  disabledBorder: normalBorder,
                  enabled: enabled,
                ),
                child: smartSelectWidget,
              );
            }

            // Without InputDecorator, build error display manually
            if (fieldState.hasError && fieldState.errorText != null) {
              final theme = Theme.of(state.context);
              final config = errorConfig ?? const SmartSelectFormFieldErrorConfig();
              final Widget errorWidget = config.errorBuilder != null
                  ? config.errorBuilder!(state.context, fieldState.errorText)
                  : Padding(
                      padding: config.errorPadding ?? const EdgeInsets.only(top: 8.0),
                      child: Text(
                        fieldState.errorText!,
                        style: config.errorStyle ??
                            TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 12.0,
                            ),
                        maxLines: config.errorMaxLines,
                        overflow: config.errorMaxLines != null ? TextOverflow.ellipsis : null,
                      ),
                    );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: config.errorBelowField
                    ? [smartSelectWidget, errorWidget]
                    : [errorWidget, smartSelectWidget],
              );
            }

            return smartSelectWidget;
          },
        );

  @override
  FormFieldState<T> createState() => _SmartSelectFormFieldState<T>();
}

class _SmartSelectFormFieldState<T> extends FormFieldState<T> {
  final GlobalKey _smartSelectKey = GlobalKey();
}

/// A [FormField] that wraps a [SmartSelect.multiple] widget.
///
/// This widget allows you to use [SmartSelect.multiple] within a [Form] and
/// benefit from form validation, save, and reset functionality.
///
/// Example:
/// ```dart
/// SmartSelectMultipleFormField<String>(
///   title: 'Categories',
///   selectedValue: _categories,
///   choiceItems: S2Choice.listFrom<String, Map>(
///     source: categories,
///     value: (index, item) => item['value'],
///     title: (index, item) => item['title'],
///   ),
///   validator: (value) {
///     if (value == null || value.isEmpty) {
///       return 'Please select at least one category';
///     }
///     return null;
///   },
///   onSaved: (value) {
///     _categories = value ?? [];
///   },
/// )
/// ```
class SmartSelectMultipleFormField<T> extends FormField<List<T>> {
  /// Creates a [FormField] that wraps a [SmartSelect.multiple] widget.
  SmartSelectMultipleFormField({
    super.key,

    // FormField parameters
    super.onSaved,
    super.validator,
    super.restorationId,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,

    // SmartSelect parameters
    String? title,
    String placeholder = 'Select one or more',
    List<T> selectedValue = const [],
    List<S2Choice<T>>? selectedChoice,
    S2MultiSelectedResolver<T>? selectedResolver,
    ValueChanged<S2MultiSelected<T>>? onChange,
    S2ChoiceSelect<S2MultiState<T>, S2Choice<T>>? onSelect,
    S2ModalOpen<S2MultiState<T>>? onModalOpen,
    S2ModalClose<S2MultiState<T>>? onModalClose,
    S2ModalWillOpen<S2MultiState<T>>? onModalWillOpen,
    S2ModalWillClose<S2MultiState<T>>? onModalWillClose,
    S2Validation<S2MultiChosen<T>>? validation,
    S2Validation<S2MultiChosen<T>>? modalValidation,
    List<S2Choice<T>>? choiceItems,
    S2ChoiceLoader<T>? choiceLoader,
    S2MultiBuilder<T>? builder,
    S2WidgetBuilder<S2MultiState<T>>? tileBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalHeaderBuilder,
    S2ListWidgetBuilder<S2MultiState<T>>? modalActionsBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalConfirmBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalDividerBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalFooterBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalFilterBuilder,
    S2WidgetBuilder<S2MultiState<T>>? modalFilterToggleBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Choice<T>>? choiceBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Choice<T>>? choiceTitleBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Choice<T>>? choiceSubtitleBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Choice<T>>? choiceSecondaryBuilder,
    IndexedWidgetBuilder? choiceDividerBuilder,
    S2WidgetBuilder<S2MultiState<T>>? choiceEmptyBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Group<T>>? groupBuilder,
    S2ComplexWidgetBuilder<S2MultiState<T>, S2Group<T>>? groupHeaderBuilder,
    S2ChoiceConfig? choiceConfig,
    S2ChoiceStyle? choiceStyle,
    S2ChoiceStyle? choiceActiveStyle,
    S2ChoiceType? choiceType,
    S2ChoiceLayout? choiceLayout,
    Axis? choiceDirection,
    bool? choiceGrouped,
    bool? choiceDivider,
    SliverGridDelegate? choiceGrid,
    int? choiceGridCount,
    double? choiceGridSpacing,
    int? choicePageLimit,
    Duration? choiceDelay,
    bool? choiceShrinkWrap,
    S2GroupConfig? groupConfig,
    bool? groupEnabled,
    bool? groupSelector,
    bool? groupCounter,
    S2GroupSort? groupSortBy,
    S2GroupHeaderStyle? groupHeaderStyle,
    S2ModalConfig? modalConfig,
    S2ModalStyle? modalStyle,
    S2ModalHeaderStyle? modalHeaderStyle,
    S2ModalType? modalType,
    String? modalTitle,
    bool? modalConfirm,
    bool? modalHeader,
    bool? modalFilter,
    bool? modalFilterAuto,
    String? modalFilterHint,
    AnimationStyle? modelAnimationStyle,

    // FormField customization
    /// Whether the field is enabled
    bool enabled = true,

    /// InputDecoration for the field (used when useInputDecorator is true)
    InputDecoration? decoration,

    /// Whether to use InputDecorator wrapper (default: true)
    /// Set to false for completely custom error display
    bool useInputDecorator = true,

    /// Configuration for error display customization
    SmartSelectFormFieldErrorConfig? errorConfig,

    /// Custom wrapper builder for complete control over the field layout
    SmartSelectFormFieldWrapperBuilder<List<T>>? wrapperBuilder,
  }) : super(
          enabled: enabled,
          initialValue: selectedValue,
          builder: (FormFieldState<List<T>> state) {
            final _SmartSelectMultipleFormFieldState<T> fieldState =
                state as _SmartSelectMultipleFormFieldState<T>;

            // Build the SmartSelect widget
            final smartSelectWidget = SmartSelect<T>.multiple(
                key: fieldState._smartSelectKey,
                title: title,
                placeholder: placeholder,
                selectedValue: fieldState.value ?? [],
                selectedChoice: selectedChoice,
                selectedResolver: selectedResolver,
                onChange: (S2MultiSelected<T> selected) {
                  fieldState.didChange(selected.value);
                  onChange?.call(selected);
                },
                onSelect: onSelect,
                onModalOpen: onModalOpen,
                onModalClose: onModalClose,
                onModalWillOpen: onModalWillOpen,
                onModalWillClose: onModalWillClose,
                validation: validation,
                modalValidation: modalValidation,
                choiceItems: choiceItems,
                choiceLoader: choiceLoader,
                builder: builder,
                tileBuilder: tileBuilder,
                modalBuilder: modalBuilder,
                modalHeaderBuilder: modalHeaderBuilder,
                modalActionsBuilder: modalActionsBuilder,
                modalConfirmBuilder: modalConfirmBuilder,
                modalDividerBuilder: modalDividerBuilder,
                modalFooterBuilder: modalFooterBuilder,
                modalFilterBuilder: modalFilterBuilder,
                modalFilterToggleBuilder: modalFilterToggleBuilder,
                choiceBuilder: choiceBuilder,
                choiceTitleBuilder: choiceTitleBuilder,
                choiceSubtitleBuilder: choiceSubtitleBuilder,
                choiceSecondaryBuilder: choiceSecondaryBuilder,
                choiceDividerBuilder: choiceDividerBuilder,
                choiceEmptyBuilder: choiceEmptyBuilder,
                groupBuilder: groupBuilder,
                groupHeaderBuilder: groupHeaderBuilder,
                choiceConfig: choiceConfig,
                choiceStyle: choiceStyle,
                choiceActiveStyle: choiceActiveStyle,
                choiceType: choiceType,
                choiceLayout: choiceLayout,
                choiceDirection: choiceDirection,
                choiceGrouped: choiceGrouped,
                choiceDivider: choiceDivider,
                choiceGrid: choiceGrid,
                choiceGridCount: choiceGridCount,
                choiceGridSpacing: choiceGridSpacing,
                choicePageLimit: choicePageLimit,
                choiceDelay: choiceDelay,
                choiceShrinkWrap: choiceShrinkWrap,
                groupConfig: groupConfig,
                groupEnabled: groupEnabled,
                groupSelector: groupSelector,
                groupCounter: groupCounter,
                groupSortBy: groupSortBy,
                groupHeaderStyle: groupHeaderStyle,
                modalConfig: modalConfig,
                modalStyle: modalStyle,
                modalHeaderStyle: modalHeaderStyle,
                modalType: modalType,
                modalTitle: modalTitle,
                modalConfirm: modalConfirm,
                modalHeader: modalHeader,
                modalFilter: modalFilter,
                modalFilterAuto: modalFilterAuto,
                modalFilterHint: modalFilterHint,
                modelAnimationStyle: modelAnimationStyle,
              );

            // If custom wrapper builder is provided, use it
            if (wrapperBuilder != null) {
              return wrapperBuilder(state.context, smartSelectWidget, state);
            }

            // Use InputDecorator if enabled
            if (useInputDecorator) {
              final theme = Theme.of(state.context);

              // Extract borderRadius from caller's decoration or use default
              final callerBorder = decoration?.border;
              final borderRadius = callerBorder is OutlineInputBorder
                  ? callerBorder.borderRadius
                  : BorderRadius.circular(8);

              // Build all border variants with consistent borderRadius
              final normalBorder = callerBorder is OutlineInputBorder
                  ? callerBorder
                  : OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: theme.dividerColor,
                        width: 1.0,
                      ),
                    );

              final errorBorderStyle = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                  width: 1.5,
                ),
              );

              final InputDecoration effectiveDecoration = (decoration ??
                      const InputDecoration())
                  .applyDefaults(theme.inputDecorationTheme);

              // Explicitly set ALL border types to prevent theme overrides
              return InputDecorator(
                decoration: effectiveDecoration.copyWith(
                  errorText: fieldState.errorText,
                  border: normalBorder,
                  enabledBorder: normalBorder,
                  focusedBorder: normalBorder,
                  errorBorder: errorBorderStyle,
                  focusedErrorBorder: errorBorderStyle,
                  disabledBorder: normalBorder,
                  enabled: enabled,
                ),
                child: smartSelectWidget,
              );
            }

            // Without InputDecorator, build error display manually
            if (fieldState.hasError && fieldState.errorText != null) {
              final theme = Theme.of(state.context);
              final config = errorConfig ?? const SmartSelectFormFieldErrorConfig();
              final Widget errorWidget = config.errorBuilder != null
                  ? config.errorBuilder!(state.context, fieldState.errorText)
                  : Padding(
                      padding: config.errorPadding ?? const EdgeInsets.only(top: 8.0),
                      child: Text(
                        fieldState.errorText!,
                        style: config.errorStyle ??
                            TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: 12.0,
                            ),
                        maxLines: config.errorMaxLines,
                        overflow: config.errorMaxLines != null ? TextOverflow.ellipsis : null,
                      ),
                    );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: config.errorBelowField
                    ? [smartSelectWidget, errorWidget]
                    : [errorWidget, smartSelectWidget],
              );
            }

            return smartSelectWidget;
          },
        );

  @override
  FormFieldState<List<T>> createState() =>
      _SmartSelectMultipleFormFieldState<T>();
}

class _SmartSelectMultipleFormFieldState<T> extends FormFieldState<List<T>> {
  final GlobalKey _smartSelectKey = GlobalKey();
}
