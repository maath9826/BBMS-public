import 'package:flutter/material.dart';

import '../web_pagination.dart';

typedef WebPaginationItemBuilder = Widget Function(
    BuildContext context, int page, ButtonType type, VoidCallback onPressed);
