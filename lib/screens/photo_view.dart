import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoPage extends StatefulWidget {
  PhotoPage({Key key}) : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

    bool verticalGallery = false;

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
     
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: new Center(
                child:
                    new Text('معرض الصور', textAlign: TextAlign.center)),

            backgroundColor: Colors.amber, // status bar color
            brightness: Brightness.dark,
            leading:  IconButton(onPressed: (){
              Navigator.of(context).pop();
            },
            
            icon: Icon(Icons.arrow_back  , color:Colors.black),
            ),
           // status bar brightness
          ),
          
          body:     Center(
            child: 
            
            
             Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GalleryExampleItemThumbnail(
                      galleryExampleItem: galleryItems[0],
                      onTap: () {
                        open(context, 0);
                      },
                    ),
                    GalleryExampleItemThumbnail(
                      galleryExampleItem: galleryItems[2],
                      onTap: () {
                        open(context, 2);
                      },
                    ),
                    GalleryExampleItemThumbnail(
                      galleryExampleItem: galleryItems[3],
                      onTap: () {
                        open(context, 3);
                      },
                    ),
                  ],
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }



    void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
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
     this.galleryExampleItem,
     this.onTap,
  }) : super(key: key);

  final GalleryExampleItem galleryExampleItem;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem.resource,
          child: Image.asset(galleryExampleItem.resource, height: 80.0),
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
  final List<GalleryExampleItem> galleryItems;
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
    final GalleryExampleItem item = widget.galleryItems[index];
    return
    PhotoViewGalleryPageOptions(
            imageProvider: 
            
            
            
            
            item.resource.startsWith("assets")
            ?
            
            
            
            
            AssetImage(item.resource)
            :NetworkImage(item.resource)
            
            ,
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.resource),
          );
  }
}