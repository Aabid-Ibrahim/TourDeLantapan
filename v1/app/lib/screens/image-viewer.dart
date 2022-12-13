import 'package:app/models/photo_model.dart';
import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<Photo> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            // Positioned(
            //   top: MediaQuery.of(context).viewPadding.top,
            //   child: Padding(
            //     padding:
            //         EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            //     child: SizedBox(
            //       width: AppBar().preferredSize.height,
            //       height: AppBar().preferredSize.height,
            //       child: Material(
            //         color: Colors.transparent,
            //         child: InkWell(
            //           borderRadius:
            //               BorderRadius.circular(AppBar().preferredSize.height),
            //           onTap: () => Navigator.pop(context),
            //           child: Icon(Icons.arrow_back_ios, color: textColor2),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              right: 15,
              bottom: MediaQuery.of(context).viewPadding.bottom,
              child: IconText(
                  color: textColor2,
                  label: "${currentIndex + 1}/${widget.galleryItems.length}"),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final Photo item = widget.galleryItems[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(item.large!),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      // heroAttributes: const PhotoViewHeroAttributes(tag: 'image-viewer'),
    );
  }
}
