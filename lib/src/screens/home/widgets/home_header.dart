import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class HomeHeader extends StatefulWidget {
  final String? name;
  final String temperature;
  final String city;
  final String condition;
  final String humidityValue;
  final String rainValue;
  final String windValue;
  final String? weatherIconCode;
  final bool isLoading;
  final VoidCallback onNotif;
  final Future<void> Function() onRefreshWeather;

  const HomeHeader({
    super.key,
    required this.name,
    required this.temperature,
    required this.city,
    required this.condition,
    required this.humidityValue,
    required this.rainValue,
    required this.windValue,
    required this.weatherIconCode,
    required this.isLoading,
    required this.onNotif,
    required this.onRefreshWeather,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        BuKombinMetrics.headerHorizontalPadding,
        MediaQuery.of(context).padding.top + BuKombinMetrics.headerTopPadding,
        BuKombinMetrics.headerHorizontalPadding,
        BuKombinMetrics.headerBottomPadding,
      ),
      decoration: BuKombinDecorations.headerBox(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Merhaba${(widget.name != null && widget.name!.isNotEmpty) ? ', ${widget.name}' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: BuKombinColors.beige1,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _HeaderActionButton(icon: Icons.notifications_none, onTap: widget.onNotif),
              const SizedBox(width: 8),
              _HeaderRefreshButton(isLoading: widget.isLoading, onTap: widget.onRefreshWeather),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BuKombinDecorations.glassSurface(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _WeatherBadge(iconCode: widget.weatherIconCode),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.city,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: BuKombinColors.beige1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.condition,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: BuKombinColors.beige1.withValues(alpha: 0.88),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.temperature,
                              style: const TextStyle(
                                color: BuKombinColors.beige1,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: BuKombinColors.beige1,
                            ),
                          ],
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 220),
                          crossFadeState: _expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: _WeatherStatsRow(
                              humidityValue: widget.humidityValue,
                              rainValue: widget.rainValue,
                              windValue: widget.windValue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherBadge extends StatelessWidget {
  final String? iconCode;

  const _WeatherBadge({required this.iconCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Icon(
        _weatherIcon(iconCode),
        color: BuKombinColors.beige1,
        size: 24,
      ),
    );
  }

  static IconData _weatherIcon(String? code) {
    switch (code) {
      case '01d':
      case '01n':
        return Icons.wb_sunny_outlined;
      case '02d':
      case '02n':
        return Icons.wb_cloudy_outlined;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.cloud_outlined;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.umbrella_outlined;
      case '11d':
      case '11n':
        return Icons.thunderstorm_outlined;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      default:
        return Icons.cloud_outlined;
    }
  }
}

class _WeatherStatsRow extends StatelessWidget {
  final String humidityValue;
  final String rainValue;
  final String windValue;

  const _WeatherStatsRow({
    required this.humidityValue,
    required this.rainValue,
    required this.windValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _WeatherMiniStat(
            icon: Icons.water_drop_outlined,
            label: 'Nem',
            value: humidityValue,
          ),
        ),
        Expanded(
          child: _WeatherMiniStat(
            icon: Icons.grain_outlined,
            label: 'Yağış',
            value: rainValue,
          ),
        ),
        Expanded(
          child: _WeatherMiniStat(
            icon: Icons.air_rounded,
            label: 'Rüzgar',
            value: windValue,
          ),
        ),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: BuKombinColors.beige1, size: 22),
        ),
      ),
    );
  }
}

class _HeaderRefreshButton extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onTap;

  const _HeaderRefreshButton({
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: isLoading ? null : () => onTap(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(BuKombinColors.beige1),
                    ),
                  )
                : const Icon(Icons.refresh, color: BuKombinColors.beige1, size: 22),
          ),
        ),
      ),
    );
  }
}

class _WeatherMiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherMiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: BuKombinColors.beige1),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: BuKombinColors.beige1.withValues(alpha: 0.84),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: BuKombinColors.beige1,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
