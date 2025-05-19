import 'package:flutter/material.dart';
import 'package:share_lingo/app/constants/app_colors.dart';
import 'package:share_lingo/presentation/pages/home/widgets/expandable_text.dart';
import 'package:share_lingo/presentation/widgets/app_cached_image.dart';

class PostItem extends StatefulWidget {
  const PostItem({super.key});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.lightGrey,
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10),
            _topBar(),
            SizedBox(height: 10),
            ExpandableText('''
I can think in English, but my mouth doesn't follow\n
Lately my English listening has gotten better, but speaking is still hard.\n
I can think in English, but my mouth doesn't follow\n
Lately my English listening has gotten better, but speaking is still hard.\n
''', trimLines: 4),
            SizedBox(height: 10),
            _imageBox(),
            SizedBox(height: 15),
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text('Tag', style: TextStyle(fontSize: 14)),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8),
                itemCount: 2,
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_outlined,
                  color: Colors.grey[500],
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '2',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _topBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: AppCachedImage(
            imageUrl: 'https://picsum.photos/200/200?random=1',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'User',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  '10m',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'KR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.sync_alt_outlined,
                    size: 16,
                    color: Colors.black26,
                  ),
                ),
                Text(
                  'EN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          icon: const Icon(Icons.keyboard_control_rounded),
        ),
      ],
    );
  }

  Widget _imageBox() {
    // 테스트용 이미지리스트
    List<String> images = [
      'https://picsum.photos/200/200?random=2',
      'https://picsum.photos/200/200?random=3',
      'https://picsum.photos/200/200?random=4',
      'https://picsum.photos/200/200?random=5',
    ];
    double sizedBoxHeight = 8;
    double sizedBoxWidth = 8;
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;

        switch (images.length) {
          case 1:
            content = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          case 2:
            content = Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          case 3:
            content = Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          case 4:
            content = Row(
              children: [
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[1]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: sizedBoxWidth),
                SizedBox(
                  width: (constraints.maxWidth - sizedBoxWidth) / 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[2]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sizedBoxHeight),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(images[3]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          default:
            content = SizedBox.shrink();
        }
        return AspectRatio(aspectRatio: 9 / 5, child: content);
      },
    );
  }
}
