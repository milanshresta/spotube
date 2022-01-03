import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlaylistCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistGenreView extends StatefulWidget {
  final String genreId;
  final String genreName;
  const PlaylistGenreView(this.genreId, this.genreName, {Key? key})
      : super(key: key);
  @override
  _PlaylistGenreViewState createState() => _PlaylistGenreViewState();
}

class _PlaylistGenreViewState extends State<PlaylistGenreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const BackButton(),
              // genre name
              Expanded(
                child: Text(
                  widget.genreName,
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Consumer<SpotifyDI>(
            builder: (context, data, child) => Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Iterable<PlaylistSimple>>(
                    future: data.spotifyApi.playlists
                        .getByCategoryId(widget.genreId)
                        .all(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error occurred"));
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return Wrap(
                        children: snapshot.data!
                            .map(
                              (playlist) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PlaylistCard(playlist),
                              ),
                            )
                            .toList(),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
