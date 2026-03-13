import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common/bukombin_top_header.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buKombinBackgroundDecoration(context),
        child: Column(
          children: [
            // ✅ Diğer sayfalardakiyle aynı "kahverengi üst alan".
            BuKombinTopHeader(
              title: 'Topluluk',
              bottom: TabBar(
                controller: _tab,
                labelColor: BuKombinColors.beige1,
                unselectedLabelColor: BuKombinColors.beige1.withOpacity(0.75),
                // İstenen: sekmelerin altındaki çizgi (underline) görünmesin.
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Akış'),
                  Tab(text: 'Liderler'),
                  Tab(text: 'Takipçiler'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _FeedTab(),
                  _LeadersTab(),
                  _FollowersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedTab extends StatelessWidget {
  const _FeedTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _PostCard(user: 'Elif', caption: 'Kahve buluşmasına kombin ☕️', likes: 128),
        SizedBox(height: 12),
        _PostCard(user: 'Mert', caption: 'Minimal ofis stili.', likes: 86),
        SizedBox(height: 12),
        _PostCard(user: 'Zeynep', caption: 'Vintage akşam yemeği.', likes: 203),
      ],
    );
  }
}

class _LeadersTab extends StatelessWidget {
  const _LeadersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _LeaderTile(rank: 1, name: 'Sude', points: 12450),
        _LeaderTile(rank: 2, name: 'Arda', points: 11820),
        _LeaderTile(rank: 3, name: 'Deniz', points: 11005),
        _LeaderTile(rank: 4, name: 'Ceren', points: 9800),
        _LeaderTile(rank: 5, name: 'Berk', points: 9450),
      ],
    );
  }
}

class _FollowersTab extends StatelessWidget {
  const _FollowersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _FollowTile(name: 'Takip Edilenler', count: 42),
        SizedBox(height: 12),
        _FollowTile(name: 'Takipçiler', count: 57),
        SizedBox(height: 12),
        _FollowTile(name: 'İstekler', count: 3),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final String user;
  final String caption;
  final int likes;

  const _PostCard({required this.user, required this.caption, required this.likes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: BuKombinColors.accent.withOpacity(0.4), child: Text(user[0])),
                const SizedBox(width: 10),
                Text(user, style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_horiz),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: BuKombinColors.accent.withOpacity(0.30)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(child: Icon(Icons.image_outlined, size: 36, color: BuKombinColors.stone2)),
            ),
            const SizedBox(height: 12),
            Text(caption, style: const TextStyle(color: BuKombinColors.brown3)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 20, color: BuKombinColors.brown2),
                const SizedBox(width: 6),
                Text('$likes', style: const TextStyle(color: BuKombinColors.stone)),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline, size: 20, color: BuKombinColors.brown2),
                const SizedBox(width: 6),
                const Text('Yorum', style: TextStyle(color: BuKombinColors.stone)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _LeaderTile extends StatelessWidget {
  final int rank;
  final String name;
  final int points;

  const _LeaderTile({required this.rank, required this.name, required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: BuKombinColors.brown2.withOpacity(0.12),
          child: Text('$rank', style: const TextStyle(color: BuKombinColors.brown2, fontWeight: FontWeight.w700)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$points puan', style: const TextStyle(color: BuKombinColors.stone)),
        trailing: OutlinedButton(onPressed: () {}, child: const Text('Takip Et')),
      ),
    );
  }
}

class _FollowTile extends StatelessWidget {
  final String name;
  final int count;

  const _FollowTile({required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.people_alt_outlined, color: BuKombinColors.brown2),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: Text('$count', style: const TextStyle(color: BuKombinColors.stone, fontWeight: FontWeight.w600)),
        onTap: () {},
      ),
    );
  }
}
