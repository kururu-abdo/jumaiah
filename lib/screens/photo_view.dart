
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jumaiah/controllers/photos_page_viewmodel.dart';
import 'package:jumaiah/enums/widget_state.dart';
import 'package:jumaiah/models/photoItem.dart';
import 'package:jumaiah/utils/Empty_widget.dart';
import 'package:jumaiah/utils/error_widget.dart';
import 'package:jumaiah/utils/loader.dart';
import 'package:jumaiah/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class PhotoPage extends StatefulWidget {
  final int propertyId;
  PhotoPage(this.propertyId, {Key key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  bool verticalGallery = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await Provider.of<PhotosPageViewModel>(context, listen: false)
          .fetchPhotos(widget.propertyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: new Text(
                'معرض الصور',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ), systemOverlayStyle: SystemUiOverlayStyle.light,
              // status bar brightness
            ),
            body: Padding(
                padding: EdgeInsets.all(8.0),
                child: Consumer<PhotosPageViewModel>(
                    builder: (context, model, child) {
                  if (model.state == WidgetState.Loading) {
                    return Center(
                      child: LoadingWidget(),
                    );
                  } else if (model.state == WidgetState.Error) {
                 
                    return Center(
                        child: CustomErrorWidget(
                      error: model.exception,
                      onPressBtn: () async {
                        await model.fetchPhotos(widget.propertyId);
                      },
                    ));
                  } else {
                    if (model.photos.length > 0) {
                      return GridView.builder(
                          itemCount: model.photos.length,
                          itemBuilder: (context, index) {
                            return GalleryExampleItemThumbnail(
                              photo: model.photos[index].image.toString(),
                              onTap: () {
                                open(context, model.photos, index);
                              },
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0));
                    } else {
                      return Center(
                        child: EmptyWidget(),
                      );
                    }
                  }
                }))
            // Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           GalleryExampleItemThumbnail(
            //             galleryExampleItem: galleryItems[0],
            //             onTap: () {
            //               open(context, 0);
            //             },
            //           ),
            //           GalleryExampleItemThumbnail(
            //             galleryExampleItem: galleryItems[2],
            //             onTap: () {
            //               open(context, 2);
            //             },
            //           ),
            //           GalleryExampleItemThumbnail(
            //             galleryExampleItem: galleryItems[3],
            //             onTap: () {
            //               open(context, 3);
            //             },
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            ),
      ),
    );
  }

  void open(BuildContext context, items, final int index) {
    var controller = Provider.of<PhotosPageViewModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: items,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}

//related classess

//model
class GalleryExampleItem {
  GalleryExampleItem({
    this.resource,
  });

  final String resource;
}

class GalleryExampleItemThumbnail extends StatelessWidget {
  const GalleryExampleItemThumbnail({
    Key key,
    this.photo,
    this.onTap,
  }) : super(key: key);

  final String photo;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<PhotosPageViewModel>(context);
    print(photo);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: "photo" + photo.toString(),
          child: Image.memory(
            controller.convertImageFromBase64(photo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

List<GalleryExampleItem> galleryItems = <GalleryExampleItem>[
  GalleryExampleItem(
    resource: "assets/gallery1.jpg",
  ),
  GalleryExampleItem(
    resource: "assets/gallery2.jpg",
  ),
  GalleryExampleItem(
    resource: "assets/gallery3.jpg",
  ),
];

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder loadingBuilder;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<PhotoItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
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
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "صورة ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.galleryItems[index].image;
    var controller = Provider.of<PhotosPageViewModel>(context, listen: false);
    return PhotoViewGalleryPageOptions(
      imageProvider: item.startsWith("assets")
          ? AssetImage(item)
          : MemoryImage(controller.convertImageFromBase64(item)),
      initialScale: PhotoViewComputedScale.contained,
      // minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      // maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item),
    );
  }
}
