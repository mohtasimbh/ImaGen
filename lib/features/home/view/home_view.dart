import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:imagen/auth/widget/drawer_widget.dart';
import 'package:imagen/core/extension/context_extensions.dart';
import 'package:imagen/features/home/viewmodel/home_viewmodel.dart';
import 'package:imagen/product/components/custom_logo.dart';
import 'package:imagen/product/components/glass_box.dart';
import 'package:imagen/product/components/image_container.dart';
import 'package:imagen/product/components/large_text.dart';
import 'package:imagen/product/components/text.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../product/enum/cache_status_enum.dart';
import '../../../product/enum/view_state.dart';
import '../../history_search/view/history_search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  //const animation
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  //const String
  final String _firstTimeText = "Now turn text into picture with ImaGen";
  final String _historyButtonText = "HISTORY";
  final String _resultsText = "Results";
  final String _loadingText = "Please Wait While Loading...";
  final String _createText = "CREATE";
  final String _hintText = "Write your Imagine";

  //const Controller
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(
        () => _transformationController.value = _animation!.value,
      );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: CustomLogo(),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          child: SizedBox(
            height: context.height,
            width: context.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: context.paddingLow,
                  child: Column(
                    children: [
                      _buildSpacer(.02),
                      _buildSearchBar(viewModel),
                      _buildSpacer(.02),
                      _buildImageStyle(viewModel),
                      _buildElevatedButon(context, viewModel),
                      _buildSpacer(.02),
                    ],
                  ),
                ),
                viewModel.state == ViewState.busy
                    ? Expanded(flex: 6, child: _buildLoadingWidget(context))
                    : viewModel.state == ViewState.idle
                        ? Expanded(
                            flex: 6,
                            child: _buildResultImageList(context, viewModel))
                        : Expanded(flex: 6, child: _buildFirstTimeText()),
                Padding(
                  padding: context.paddingLow,
                  child: GlassContainer(
                    child: SizedBox(
                      width: context.width * .95,
                      height: context.height * .05,
                      child: TextButton(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.downloading_rounded,
                                color: Colors.white),
                            const SizedBox(
                              width: 5,
                            ),
                            CustomText(
                              text: 'Download',
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                viewModel.cacheStatus == CacheStatus.available
                    ? Expanded(
                        flex: 1,
                        child: _buildHistorySearchButton(context, viewModel))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center _buildFirstTimeText() {
    return Center(
      child: CustomText(
        text: _firstTimeText,
        isCenter: true,
      ),
    );
  }

  Padding _buildHistorySearchButton(
      BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: context.paddingLow,
      child: GlassContainer(
        child: SizedBox(
          width: context.width * .95,
          height: context.height * .05,
          child: TextButton(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, color: Colors.white),
                const SizedBox(
                  width: 5,
                ),
                CustomText(
                  text: _historyButtonText,
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: viewModel,
                    child: const HistorySearchView(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _buildResultImageList(BuildContext context, HomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ListView(
        children: [
          Padding(
            padding: context.paddingLow,
            child: CustomLargeText(text: _resultsText),
          ),
          _buildSpacer(.02),
          SizedBox(
            height: context.height * .5,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: viewModel.dallEModel?.data?.length ?? 0,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var dallEModel = viewModel.dallEModel;
                return GestureDetector(
                  onTap: () {
                    showImageViewer(context,
                        Image.network(dallEModel?.data?[index].url ?? "").image,
                        swipeDismissible: true, doubleTapZoomable: true);
                  },
                  child: ImageContainer(
                    context: context,
                    model: dallEModel,
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void resetAnimation() {
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward(from: 0);
  }

  SizedBox _buildLoadingWidget(BuildContext context) {
    return SizedBox(
      height: context.height * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: 70,
              color: Colors.white,
            ),
          ),
          _buildSpacer(.03),
          CustomText(text: _loadingText)
        ],
      ),
    );
  }

  GlassContainer _buildElevatedButon(
      BuildContext context, HomeViewModel viewModel) {
    return GlassContainer(
      child: SizedBox(
        width: context.width * .95,
        height: context.height * .04,
        child: TextButton(
          child: CustomText(
            text: _createText,
          ),
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              FocusManager.instance.primaryFocus?.unfocus();
              viewModel.getImage(prompt: _searchController.text);
            }
          },
        ),
      ),
    );
  }

  SizedBox _buildImageStyle(HomeViewModel viewModel) {
    return SizedBox(
      height: context.height * .08,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: viewModel.typeList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var type = viewModel.typeList[index];
          return InkWell(
            onTap: () {
              viewModel.changeSelected(index);
            },
            child: Padding(
              padding: context.paddingLow,
              child: GlassContainer(
                color: type.isSelected ? const Color(0xFF00f9ff) : Colors.white,
                child: Container(
                  margin: context.paddingLow,
                  child: Row(
                    children: [
                      Icon(
                        type.icon,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      CustomText(
                        text: type.title ?? "",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  GlassContainer _buildSearchBar(HomeViewModel viewModel) {
    return GlassContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          Expanded(
            flex: 9,
            child: TextFormField(
              readOnly: viewModel.state == ViewState.busy ? true : false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: _hintText),
              controller: _searchController,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildSpacer(double size) => SizedBox(height: context.height * size);
}
