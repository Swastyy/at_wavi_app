import 'dart:io';

import 'package:at_wavi_app/desktop/services/theme/app_theme.dart';
import 'package:at_wavi_app/desktop/widgets/desktop_video_thumbnail_widget.dart';
import 'package:at_wavi_app/model/user.dart';
import 'package:flutter/cupertino.dart';

class DesktopMediaItem extends StatelessWidget {
  BasicData data;

  DesktopMediaItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            child: Text(
              data.accountName ?? '',
              style: TextStyle(
                  fontSize: 12,
                  color: appTheme.secondaryTextColor,
                  fontFamily: 'Inter'),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            width: 200,
            height: 200,
            child: (data.type == 'jpg' || data.type == 'png')
                ? Image.file(
                    File(data.path!),
                    fit: BoxFit.fitWidth,
                  )
                : DesktopVideoThumbnailWidget(
                    path: data.path!,
                    type: data.type ?? '',
                  ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
