import 'dart:io';
import 'dart:typed_data';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/desktop_dimens.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/desktop/widgets/buttons/desktop_icon_label_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_button.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_show_hide_radio_button.dart';
import 'package:at_wavi_app/desktop/widgets/textfields/desktop_textfield.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:at_wavi_app/utils/at_enum.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'desktop_profile_add_custom_field_model.dart';
import 'widgets/desktop_html_editor_page.dart';
import 'widgets/desktop_html_preview_page.dart';

class DesktopProfileAddCustomField extends StatefulWidget {
  final String title;
  final AtCategory atCategory;
  final BasicData? data;
  final List<CustomContentType> allowContentType;

  DesktopProfileAddCustomField({
    Key? key,
    this.title = Strings.desktop_add_custom_content,
    required this.atCategory,
    this.data,
    this.allowContentType = const [
      CustomContentType.Text,
      CustomContentType.Link,
      CustomContentType.Number,
      CustomContentType.Image,
      CustomContentType.Youtube,
      CustomContentType.Html,
    ],
  }) : super(key: key);

  @override
  _DesktopProfileAddCustomFieldState createState() =>
      _DesktopProfileAddCustomFieldState();
}

class _DesktopProfileAddCustomFieldState
    extends State<DesktopProfileAddCustomField> {
  late DesktopAddBasicDetailModel _model;
  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
    _isUpdate = widget.data != null;
    if (widget.data != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopAddBasicDetailModel(
          userPreview: userPreview,
          atCategory: widget.atCategory,
          originBasicData: widget.data,
          allowContentType: widget.allowContentType,
        );
        // _model.setIsOnlyAddMedia(widget.isOnlyAddImage);
        return _model;
      },
      child: Consumer<DesktopAddBasicDetailModel>(
        builder: (_, model, child) {
          return Container(
            width: DesktopDimens.dialogWidth,
            padding: EdgeInsets.all(DesktopDimens.paddingNormal),
            decoration: BoxDecoration(
              color: appTheme.backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: appTheme.primaryTextColor,
                  ),
                ),
                SizedBox(height: DesktopDimens.paddingNormal),
                DesktopTextField(
                  title: Strings.desktop_title,
                  controller: model.titleTextController,
                ),
                _buildTypeSelectionWidget(model),
                _buildFieldInputWidget(model),
                Container(height: 1, color: appTheme.separatorColor),
                SizedBox(height: DesktopDimens.paddingNormal),
                DesktopShowHideRadioButton(
                  controller: model.showHideController,
                ),
                SizedBox(height: DesktopDimens.paddingNormal),
                DesktopButton(
                  title: Strings.desktop_done,
                  width: double.infinity,
                  onPressed: _onSaveData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeSelectionWidget(DesktopAddBasicDetailModel model) {
    final appTheme = AppTheme.of(context);
    return Consumer<DesktopAddBasicDetailModel>(
      builder: (_, model, child) {
        return DropdownButtonFormField<CustomContentType>(
          dropdownColor: appTheme.backgroundColor,
          autovalidateMode: AutovalidateMode.disabled,
          hint: Text(Strings.desktop_select_type),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appTheme.separatorColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: appTheme.primaryColor),
            ),
          ),
          value: model.fieldType ?? widget.allowContentType.first,
          icon: Icon(Icons.keyboard_arrow_down),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appTheme.primaryTextColor,
          ),
          validator: (value) {
            if (value == null) {
              return Strings.desktop_please_select_type;
            }
            return null;
          },
          onChanged: (newValue) {
            if (newValue != null) {
              _model.changeField(newValue);
            }
          },
          items: widget.allowContentType.map<DropdownMenuItem<CustomContentType>>(
              (CustomContentType value) {
            return DropdownMenuItem<CustomContentType>(
              value: value,
              child: Text(value.label),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFieldInputWidget(DesktopAddBasicDetailModel model) {
    return Consumer<DesktopAddBasicDetailModel>(
      builder: (_, model, child) {
        if (model.fieldType == CustomContentType.Text) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: '',
          );
        } else if (model.fieldType == CustomContentType.Link) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: 'https:www//example.com',
          );
        } else if (_model.fieldType == CustomContentType.Number) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: '',
          );
        } else if (model.fieldType == CustomContentType.Image) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesktopIconLabelButton(
                  iconData: Icons.add,
                  label: Strings.desktop_add_media,
                  onPressed: _onSelectMedia,
                  isPrefixIcon: false,
                  padding: EdgeInsets.zero,
                ),
                SizedBox(
                  width: DesktopDimens.paddingSmall,
                ),
                if (model.selectedMedia != null)
                  _buildMediaWidget(model.selectedMedia),
              ],
            ),
          );
        } else if (model.fieldType == CustomContentType.Youtube) {
          return DesktopTextField(
            controller: model.valueContentTextController,
            hint: 'https://www.youtube.com',
          );
        } else if (model.fieldType == CustomContentType.Html) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: DesktopDimens.paddingSmall),
            child: DesktopHtmlEditorPage(
              textController: _model.valueContentTextController,
              onPreviewPressed: _openHtmlPreview,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildMediaWidget(Uint8List? uInt8list) {
    final appTheme = AppTheme.of(context);
    // if (extension == 'jpg' || extension == 'png') {
    if (uInt8list == null) {
      return Container();
    }
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120.0,
      ),
      margin: EdgeInsets.all(DesktopDimens.paddingSmall),
      child: Image.memory(uInt8list),
      decoration: BoxDecoration(
          border: Border.all(color: appTheme.secondaryTextColor, width: 1)),
    );
    // } else {
    //   return DesktopVideoThumbnailWidget(
    //     path: path,
    //     extension: extension ?? '',
    //   );
    // }
  }

  void _onSelectMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result?.files.single.path != null) {
      File file = File(result!.files.single.path);
      await _model.didSelectMedia(file);
    } else {
      // User canceled the picker
    }
  }

  void _onSaveData() {
    if (_isUpdate) {
      _model.updateCustomField(context);
    } else {
      _model.addCustomField(context);
    }
  }

  void _openHtmlPreview() {
    final html = _model.valueContentTextController.text.trim();
    if (html.isEmpty) {
      return;
    }
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        child: DesktopHtmlPreviewPage(html: html),
      ),
    );
  }
}
