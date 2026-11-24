import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/services/notification/notification_service.dart';
import '../../settings/data/datasources/settings_local_data_source.dart';
import '../../settings/presentation/models/muadhin_option.dart';
import '../presentation/models/adhan_args.dart';
import '../presentation/views/widgets/adhan_actions_bar.dart';
import '../presentation/views/widgets/adhan_atmospheric_background.dart';
import '../presentation/views/widgets/adhan_header.dart';
import '../presentation/views/widgets/adhan_post_duaa_card.dart';
import '../presentation/views/widgets/adhan_visualizer_wave.dart';

class AdhanScreen extends StatefulWidget {
  final AdhanArgs? args;

  const AdhanScreen({super.key, this.args});

  @override
  State<AdhanScreen> createState() => _AdhanScreenState();
}

class _AdhanScreenState extends State<AdhanScreen> {
  late final AudioPlayer _audioPlayer;
  late AdhanArgs _args;
  late MuadhinOption _muadhin;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _args = widget.args ??
        AdhanArgs(
          prayerKey: 'fajr',
          prayerName: 'الفجر',
          prayerTime: DateTime.now(),
        );

    _initMuezzinAndAudio();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is AdhanArgs) {
      _args = routeArgs;
    } else if (routeArgs is Map<String, dynamic>) {
      _args = AdhanArgs.fromMap(routeArgs);
    } else if (routeArgs is String) {
      _args = AdhanArgs.fromPayload(routeArgs);
    }
  }

  Future<void> _initMuezzinAndAudio() async {
    // Silence any native background notification sound so AdhanScreen manages it
    try {
      await di.sl<NotificationService>().cancelAll();
    } catch (_) {}

    final settingsDs = di.sl<SettingsLocalDataSource>();
    final savedId = settingsDs.getMuadhinVoice();
    _muadhin = MuadhinOption.defaultList.firstWhere(
      (m) => m.id == savedId,
      orElse: () => MuadhinOption.defaultList.first,
    );

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    try {
      final isFajr = _args.prayerKey.toLowerCase() == 'fajr';
      final path = isFajr ? _muadhin.fajrAudioPath : _muadhin.regularAudioPath;
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource(path));
    } catch (_) {
      // Audio playback fallback
    }
  }

  Future<void> _stopAdhan() async {
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _closeScreen() {
    _audioPlayer.stop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _audioPlayer.stop();
      },
      child: Scaffold(
        body: Stack(
          children: [
            AdhanAtmosphericBackground(prayerKey: _args.prayerKey),
            SafeArea(
              child: Column(
                children: [
                  AdhanHeader(
                    prayerName: _args.prayerName,
                    prayerTime: _args.prayerTime,
                    muezzinName: _muadhin.nameKey.tr(),
                    onClose: _closeScreen,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          AdhanVisualizerWave(isPlaying: _isPlaying),
                          const SizedBox(height: 20),
                          const AdhanPostDuaaCard(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  AdhanActionsBar(
                    isPlaying: _isPlaying,
                    onStopAdhan: _stopAdhan,
                    onClose: _closeScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
