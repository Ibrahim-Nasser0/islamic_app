import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/di/injection_container.dart' as di;
import 'package:islamic_app/core/services/notification/notification_service.dart';
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
  MuadhinOption _muadhin = MuadhinOption.defaultList.first;
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

    // Initialize muezzin synchronously before build() can run
    try {
      final settingsDs = di.sl<SettingsLocalDataSource>();
      final savedId = settingsDs.getMuadhinVoice();
      _muadhin = MuadhinOption.defaultList.firstWhere(
        (m) => m.id == savedId,
        orElse: () => MuadhinOption.defaultList.first,
      );
    } catch (_) {}

    _initAudioPlayback();
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

  Future<void> _cancelActiveNotification() async {
    final id = _args.notificationId;
    if (id == null) return;
    try {
      await di.sl<NotificationService>().cancel(id);
    } catch (_) {}
  }

  Future<void> _initAudioPlayback() async {
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
      await _cancelActiveNotification();
    } catch (_) {
      // Audio fallback
    }
  }

  Future<void> _stopAdhan() async {
    await _cancelActiveNotification();
    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  void _closeScreen() {
    _cancelActiveNotification();
    _audioPlayer.stop();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _cancelActiveNotification();
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
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: AdhanHeader(
                      prayerName: _args.prayerName,
                      prayerTime: _args.prayerTime,
                      muezzinName: _muadhin.nameKey.tr(),
                      onClose: _closeScreen,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          FadeIn(
                            duration: const Duration(milliseconds: 800),
                            delay: const Duration(milliseconds: 200),
                            child: AdhanVisualizerWave(isPlaying: _isPlaying),
                          ),
                          const SizedBox(height: 16),
                          FadeInUp(
                            duration: const Duration(milliseconds: 700),
                            delay: const Duration(milliseconds: 350),
                            child: const AdhanPostDuaaCard(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SlideInUp(
                    duration: const Duration(milliseconds: 500),
                    child: AdhanActionsBar(
                      isPlaying: _isPlaying,
                      onStopAdhan: _stopAdhan,
                      onClose: _closeScreen,
                    ),
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
