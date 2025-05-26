import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  List<dynamic> _badges = [];
  List<dynamic> _activityHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await ApiService().getProfile();
      final badges = await ApiService().getBadges();
      final activity = await ApiService().getActivityHistory();
      setState(() {
        _userData = profile;
        _badges = badges;
        _activityHistory = activity;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppGradients.backgroundGradient,
            ),
          ),
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Erreur: \\$_error'))
                    : _userData == null
                        ? const Center(child: Text('Aucune donnée utilisateur'))
                        : CustomScrollView(
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              // App bar
                              SliverAppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                leading: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardDark.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                                actions: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardDark.withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.settings,
                                        color: AppColors.accent,
                                      ),
                                      onPressed: () {
                                        // Open settings
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              // User profile header
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: _buildProfileHeader(),
                                ),
                              ),
                              // Stats summary
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: _buildStatsSummary(),
                                ),
                              ),
                              // Section title
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
                                  child: Text(
                                    "Activité récente",
                                    style: AppTextStyles.subheading,
                                  ),
                                ),
                              ),
                              // Activity history (placeholder or from API)
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final activity = _activityHistory.isNotEmpty
                                        ? _activityHistory[index]
                                        : null;
                                    return activity != null
                                        ? Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                            child: _buildActivityItem(activity),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                            child: Text('Aucune activité récente'),
                                          );
                                  },
                                  childCount: _activityHistory.isNotEmpty ? _activityHistory.length : 1,
                                ),
                              ),
                              // Badges section (optional: fetch from API if available)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Badges débloqués",
                                        style: AppTextStyles.subheading,
                                      ),
                                      const SizedBox(height: 16),
                                      _buildBadgesGrid(),
                                    ],
                                  ),
                                ),
                              ),
                              // Logout button
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.error,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(AppRadius.lg),
                                        ),
                                      ),
                                      icon: const Icon(Icons.logout, color: Colors.white),
                                      label: Text('Se déconnecter', style: AppTextStyles.button.copyWith(color: Colors.white)),
                                      onPressed: () async {
                                        await ApiService().logout();
                                        if (!mounted) return;
                                        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // Bottom spacing
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 50),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
  
  // Profile header with avatar and user info
  Widget _buildProfileHeader() {
    if (_userData == null) return const SizedBox.shrink();
    return Column(
      children: [
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: _userData!["avatar"] != null && _userData!["avatar"].toString().isNotEmpty
                ? Image.network(_userData!["avatar"], fit: BoxFit.cover)
                : const Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        
        // User name
        Text(
          _userData!["name"] ?? '',
          style: AppTextStyles.displayMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // User email
        Text(
          _userData!["email"] ?? '',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        
        // Member since (optional)
        if (_userData!["memberSince"] != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.quaternary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.circular),
            ),
            child: Text(
              "Membre depuis \\${_userData!["memberSince"]}",
              style: AppTextStyles.caption.copyWith(
                color: AppColors.quaternary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        // Bio
        if (_userData!["bio"] != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              _userData!["bio"],
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ),
        
        // Edit profile button
        FuturisticUI.techButton(
          label: "MODIFIER LE PROFIL",
          onPressed: () async {
            final result = await Navigator.pushNamed(context, AppRoutes.editProfile, arguments: _userData);
            if (result == true) {
              _fetchProfile();
            }
          },
          icon: Icons.edit,
          color: AppColors.accent,
        ),
      ],
    );
  }
  
  // Stats summary grid
  Widget _buildStatsSummary() {
    if (_userData == null) return const SizedBox.shrink();
    return FuturisticUI.glassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vos statistiques",
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                (_userData!["totalScans"] ?? 0).toString(), 
                "Scans", 
                Icons.camera_alt
              ),
              _buildStatItem(
                (_userData!["animalsIdentified"] ?? 0).toString(), 
                "Animaux identifiés", 
                Icons.pets
              ),
              _buildStatItem(
                "4.8/5", 
                "Note moyenne", 
                Icons.star
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Single stat item
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  // Activity item
  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return FuturisticUI.glassContainer(
      padding: const EdgeInsets.all(12),
      opacity: 0.05,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                activity['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Activity info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildActivityIcon(activity['type']),
                    const SizedBox(width: 6),
                    Text(
                      _getActivityTypeLabel(activity['type']),
                      style: AppTextStyles.caption.copyWith(
                        color: _getActivityColor(activity['type']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity['title'],
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activity['date'],
                      style: AppTextStyles.caption,
                    ),
                    if (activity.containsKey('location')) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity['location'],
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Activity type icon
  Widget _buildActivityIcon(String type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case 'scan':
        icon = Icons.camera_alt;
        color = AppColors.accent;
        break;
      case 'bookmark':
        icon = Icons.bookmark;
        color = AppColors.secondary;
        break;
      case 'explore':
        icon = Icons.explore;
        color = AppColors.quaternary;
        break;
      default:
        icon = Icons.history;
        color = AppColors.textHint;
    }
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 10,
      ),
    );
  }
  
  // Get color based on activity type
  Color _getActivityColor(String type) {
    switch (type) {
      case 'scan':
        return AppColors.accent;
      case 'bookmark':
        return AppColors.secondary;
      case 'explore':
        return AppColors.quaternary;
      default:
        return AppColors.textHint;
    }
  }
  
  // Get label based on activity type
  String _getActivityTypeLabel(String type) {
    switch (type) {
      case 'scan':
        return 'SCAN';
      case 'bookmark':
        return 'FAVORI';
      case 'explore':
        return 'EXPLORATION';
      default:
        return 'ACTIVITÉ';
    }
  }
  
  // Badges grid
  Widget _buildBadgesGrid() {
    if (_badges.isEmpty) {
      return Center(
        child: Text('Aucun badge débloqué', style: AppTextStyles.caption),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _badges.length,
      itemBuilder: (context, index) {
        final badge = _badges[index];
        return _buildBadgeItem(badge);
      },
    );
  }
  
  // Badge item
  Widget _buildBadgeItem(dynamic badge) {
    // Use badge_name, badge_image, awarded_at from API
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: badge['badge_image'] != null && badge['badge_image'].toString().isNotEmpty
              ? Image.network(badge['badge_image'], fit: BoxFit.cover)
              : const Icon(Icons.emoji_events, color: AppColors.accent, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          badge['badge_name'] ?? '',
          style: AppTextStyles.caption.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (badge['awarded_at'] != null)
          Text(
            'Débloqué',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
} 