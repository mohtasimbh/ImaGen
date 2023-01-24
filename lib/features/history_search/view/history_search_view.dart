import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:imagen/core/extension/context_extensions.dart';
import 'package:imagen/features/home/model/ai_model.dart';
import 'package:imagen/features/home/viewmodel/home_viewmodel.dart';
import 'package:imagen/product/components/image_container.dart';
import 'package:imagen/product/components/large_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../product/components/text.dart';

class HistorySearchView extends StatelessWidget {
  const HistorySearchView({Key? key}) : super(key: key);
  final String _historyText = "Search History";
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: CustomLargeText(text: _historyText),
        
      ),
      body: Column(
        children: [
          _buildSpacer(context),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: viewModel.modelList?.length ?? 0,
              itemBuilder: (context, index) {
                var historyModel = viewModel.modelList?[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(context, historyModel),
                    _buildImageList(context, historyModel),
                    _buildDivider(context),
                    _buildSpacer(context),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSpacer(BuildContext context) {
    return SizedBox(
      height: context.height * .03,
    );
  }

  Center _buildDivider(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * .95,
        height: 3,
        color: Colors.grey.withOpacity(.2),
      ),
    );
  }

  SizedBox _buildImageList(BuildContext context, DallEModel? historyModel) {
    return SizedBox(
      height: context.height * 0.4,
      child: ListView.builder(
        itemCount: historyModel?.data?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showImageViewer(context,
                  Image.network(historyModel?.data?[index].url ?? "").image,
                  swipeDismissible: true, doubleTapZoomable: true);
            },
            child: ImageContainer(
              context: context,
              model: historyModel,
              index: index,
            ),
          );
        },
      ),
    );
  }

  Padding _buildTitle(BuildContext context, DallEModel? historyModel) {
    return Padding(
      padding: context.paddingLeft,
      child: CustomText(
        text: historyModel?.title.toString().firstUpperCase() ?? "",
        size: 20,
      ),
    );
  }
}
