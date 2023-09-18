import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb_example/domain/api_client/image_downloader.dart';
import 'package:themoviedb_example/ui/navigation/main_navigation.dart';
import 'package:themoviedb_example/ui/widgets/elements/radial_percent_widget.dart';
import 'package:themoviedb_example/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPostersWidget(),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);
    return Text(
      overview,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Overview',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    return AspectRatio(
      aspectRatio: 411 / 231,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
          if (posterPath != null)
            Positioned(
                top: 20,
                left: 20,
                bottom: 20,
                child: Image.network(ImageDownloader.imageUrl(posterPath))),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(color: Colors.pinkAccent, posterData.favoriteIcon),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = context.select((MovieDetailsModel model) => model.data.nameData);

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: data.name,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: data.year,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreData =
        context.select((MovieDetailsModel model) => model.data.scoreData);
    final trailerKey = scoreData.trailerKey;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: RadialPercentWidget(
                    percent: scoreData.voteAverage / 100,
                    fillColor: const Color.fromARGB(255, 10, 23, 25),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineWidth: 3,
                    child: Text(scoreData.voteAverage.toStringAsFixed(0)),
                  ),
                ),
                const Text('User Score'),
              ],
            )),
        Container(
          width: 1,
          height: 15,
          color: Colors.grey,
        ),
        if (trailerKey != null)
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
              MainNavigationRouteNames.movieTrailerWidget,
              arguments: trailerKey,
            ),
            child: const Row(
              children: [
                Icon(Icons.play_arrow),
                Text('Play Trailer'),
              ],
            ),
          ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsModel model) => model.data.summary);
    return ColoredBox(
      color: const Color.fromRGBO(29, 29, 48, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          summary,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew =
        context.select((MovieDetailsModel model) => model.data.peopleData);
    if (crew.isEmpty) return const SizedBox.shrink();

    return Column(
      children: crew
          .map(
            (chunk) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _PeopleWidgetsRow(employees: chunk),
            ),
          )
          .toList(),
      // [_PeopleWidgetsRow(), const SizedBox(height: 20), _PeopleWidgetsRow()],
    );
  }
}

class _PeopleWidgetsRow extends StatelessWidget {
  final List<MovieDetailsMoviePeopleData> employees;

  const _PeopleWidgetsRow({
    Key? key,
    required this.employees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        children: employees
            .map((employee) => _PeopleWidgetsRowItem(employee: employee))
            .toList());
  }
}

class _PeopleWidgetsRowItem extends StatelessWidget {
  final MovieDetailsMoviePeopleData employee;
  const _PeopleWidgetsRowItem({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    const jobTitleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: nameStyle),
          Text(employee.job, style: jobTitleStyle),
        ],
      ),
    );
  }
}
