import 'dart:ui';

import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
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

  static const _textLight = Color(0xFFE8DDD5);
  static const _g1 = Color(0xFF5C4033);
  static const _g2 = Color(0xFF4A3428);
  static const _g3 = Color(0xFF3E2723);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: _g2.withOpacity(0.30),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_g1, _g2, _g3],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Merhaba${(name != null && name!.isNotEmpty) ? ', $name' : ''}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _HeaderActionButton(icon: Icons.notifications_none, onTap: onNotif),
              const SizedBox(width: 8),
              _HeaderRefreshButton(isLoading: isLoading, onTap: onRefreshWeather),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.22)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _WeatherBadge(iconCode: weatherIconCode),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _textLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                condition,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _textLight.withOpacity(0.88),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          temperature,
                          style: const TextStyle(
                            color: _textLight,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _WeatherStatsRow(
                      humidityValue: humidityValue,
                      rainValue: rainValue,
                      windValue: windValue,
                    ),
                  ],
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
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.20)),
      ),
      child: Icon(
        _weatherIcon(iconCode),
        color: const Color(0xFFE8DDD5),
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
      color: Colors.white.withOpacity(0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: const Color(0xFFE8DDD5), size: 22),
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
      color: Colors.white.withOpacity(0.10),
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
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE8DDD5)),
                    ),
                  )
                : const Icon(Icons.refresh, color: Color(0xFFE8DDD5), size: 22),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFFE8DDD5)),
          const SizedBox(height: 6),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFFE8DDD5).withOpacity(0.76),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFFE8DDD5),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
