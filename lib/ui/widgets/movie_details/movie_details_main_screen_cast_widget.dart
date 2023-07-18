import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_example/domain/api_client/image_downloader.dart';

import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_model.dart';

class MoviedDetailsMainScreenCastWidget extends StatelessWidget {
  const MoviedDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Top Billed Cast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(
          height: 260,
          child: Scrollbar(
            child: _ActorWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextButton(
              onPressed: () {}, child: const Text('Full Cast & Crew')),
        )
      ]),
    );
  }
}

class _ActorWidget extends StatelessWidget {
  const _ActorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data =
        context.select((MovieDetailsModel model) => model.data.actorsData);

    if (data.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      itemCount: data.length,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorListItemWidget(actorIndex: index);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;

  const _ActorListItemWidget({
    Key? key,
    required this.actorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final actor = model.data.actorsData[actorIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              if (profilePath != null)
                Image.network(
                  ImageDownloader.imageUrl(profilePath),
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        actor.name,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        actor.character,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
