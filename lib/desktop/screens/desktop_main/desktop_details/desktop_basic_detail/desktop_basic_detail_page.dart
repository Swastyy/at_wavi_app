import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/utils/strings.dart';
import 'package:at_wavi_app/utils/colors.dart';
import 'package:at_wavi_app/view_models/user_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../desktop_basic_item.dart';
import 'desktop_basic_detail_model.dart';

class DesktopBasicDetailPage extends StatefulWidget {
  DesktopBasicDetailPage({Key? key}) : super(key: key);

  _DesktopBasicDetailPageState _desktopBasicDetailPageState =
      _DesktopBasicDetailPageState();

  @override
  _DesktopBasicDetailPageState createState() => _desktopBasicDetailPageState;
}

class _DesktopBasicDetailPageState extends State<DesktopBasicDetailPage>
    with AutomaticKeepAliveClientMixin<DesktopBasicDetailPage> {
  late DesktopBasicDetailModel _model;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext c) {
        final userPreview = Provider.of<UserPreview>(context);
        _model = DesktopBasicDetailModel(userPreview: userPreview);
        return _model;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ColorConstants.LIGHT_GREY,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Consumer<DesktopBasicDetailModel>(
              builder: (_, model, child) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.fields.length,
                  itemBuilder: (context, index) {
                    return DesktopBasicItem(
                      title: getTitle(model.fields[index]),
                      value: '',
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 1,
                        color: appTheme.borderColor,
                      ),
                    );
                  },
                );
                //   Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       DesktopBasicItem(
                //         title: Strings.desktop_phone_number,
                //         value: '+84 3354335562',
                //       ),
                //       Container(
                //         height: 1,
                //         margin: EdgeInsets.symmetric(horizontal: 16),
                //         color: appTheme.borderColor,
                //       ),
                //       DesktopBasicItem(
                //         title: Strings.desktop_email_address,
                //         value: 'duc1@gmail.com',
                //       ),
                //     ],
                //   );
              },
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  String getTitle(String field) {
    switch (field) {
      case 'phone':
        return Strings.desktop_phone_number;
      case 'email':
        return Strings.desktop_email_address;
      default:
        return '';
    }
  }
}
