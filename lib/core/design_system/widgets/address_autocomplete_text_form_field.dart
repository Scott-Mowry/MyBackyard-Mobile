import 'package:backyard/core/dependencies/dependency_injector.dart';
import 'package:backyard/core/design_system/theme/custom_colors.dart';
import 'package:backyard/core/helper/debouncer.dart';
import 'package:backyard/core/model/address_suggestion_model.dart';
import 'package:backyard/core/model/place_details_model.dart';
import 'package:backyard/core/repositories/google_maps_repository.dart';
import 'package:backyard/legacy/Component/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddressAutocompleteTextFormField extends StatefulWidget {
  final String? hintText;
  final String? title;

  final ValueChanged<PlaceDetailsModel>? onAddressSelected;

  final TextEditingController? controller;
  final String? Function(String?)? validation;
  final ValueChanged<String>? onFieldSubmitted;

  final double? borderRadius;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? borderColor;
  final bool fullBorder;
  final bool enable;
  final FocusNode? focusNode;

  const AddressAutocompleteTextFormField({
    super.key,
    this.hintText,
    this.title,
    this.onAddressSelected,
    this.controller,
    this.validation,
    this.onFieldSubmitted,
    this.borderRadius = 10,
    this.backgroundColor,
    this.hintTextColor = const Color(0xff374856),
    this.textColor = Colors.black,
    this.borderColor = Colors.white,
    this.fullBorder = true,
    this.enable = true,
    this.focusNode,
  });

  @override
  State<AddressAutocompleteTextFormField> createState() => _AddressAutocompleteTextFormFieldState();
}

class _AddressAutocompleteTextFormFieldState extends State<AddressAutocompleteTextFormField> {
  final _debouncer = Debouncer(milliseconds: 500);
  late final _internalController = widget.controller ?? TextEditingController();
  TextEditingController? _autocompleteController;

  var _lastQuery = '';
  final _lastSuggestions = <AddressSuggestionModel>[];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<AddressSuggestionModel>(
      optionsBuilder: optionsBuilder,
      displayStringForOption: (val) => val.description ?? '',
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        // Sync the autocomplete controller with our internal controller
        if (_autocompleteController != textEditingController) {
          _autocompleteController = textEditingController;
          if (_internalController.text.isNotEmpty && textEditingController.text.isEmpty) {
            textEditingController.text = _internalController.text;
          }
        }

        return CustomTextFormField(
          controller: textEditingController,
          focusNode: widget.focusNode ?? focusNode,
          validation: widget.validation,
          prefixWidget: Icon(Icons.map, color: CustomColors.primaryGreenColor),
          onFieldSubmit: (val) {
            onFieldSubmitted();
            widget.onFieldSubmitted?.call(val);
          },
          hintText: widget.hintText,
          title: widget.title,
          borderRadius: widget.borderRadius,
          backgroundColor: widget.backgroundColor,
          hintTextColor: widget.hintTextColor,
          textColor: widget.textColor,
          borderColor: widget.borderColor,
          fullBorder: widget.fullBorder,
          enable: widget.enable,
        );
      },
      optionsViewBuilder: (context, _, options) {
        return Align(
          alignment: AlignmentDirectional.topStart,
          child: Material(
            elevation: 4.0,
            color: widget.backgroundColor ?? CustomColors.secondaryColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200.0, maxWidth: MediaQuery.sizeOf(context).width * 0.9),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder:
                    (context, index) =>
                        Divider(height: 1, color: CustomColors.prefixContainerColor.withValues(alpha: 0.3)),
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Builder(
                      builder: (context) {
                        return Container(
                          color: CustomColors.prefixContainerColor.withValues(alpha: 0.2),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on_outlined, color: CustomColors.primaryGreenColor, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option.description ?? '',
                                  style: GoogleFonts.roboto(fontSize: 14, color: widget.textColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List<AddressSuggestionModel>> optionsBuilder(TextEditingValue val) async {
    if (val.text.length < 3 || val.text == _lastQuery) return _lastSuggestions;

    _lastQuery = val.text;
    final suggestions = await _debouncer.run(
      () async => getIt<GoogleMapsRepository>().getAddressesByQuery(val.text),
      orElse: _lastSuggestions,
    );

    _lastSuggestions.clear();
    _lastSuggestions.addAll(suggestions);

    return suggestions;
  }

  Future<void> onSelected(AddressSuggestionModel address) async {
    final details = await getIt<GoogleMapsRepository>().getPlaceDetails(address.placeId!);
    widget.onAddressSelected?.call(details!);

    final description = address.description ?? '';
    _lastQuery = description;
    _internalController.text = description;
    _autocompleteController!.text = description;

    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  void dispose() {
    if (widget.controller == null) _internalController.dispose();
    _debouncer.dispose();
    super.dispose();
  }
}
