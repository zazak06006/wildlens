import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/widgets/config.dart';
import 'package:flutter_application_1/widgets/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Alex Durand',
    'email': 'alex.durand@example.com',
    'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2670&auto=format&fit=crop',
    'bio': 'Passionné de nature et amateur de randonnée. Je documente la faune sauvage lors de mes excursions.',
    'totalScans': 42,
    'animalsIdentified': 18,
    'favoriteBiome': 'Forêt tempérée',
    'memberSince': 'Mars 2024',
  };
  
  // Mock activity history
  final List<Map<String, dynamic>> _activityHistory = [
    {
      'type': 'scan',
      'title': 'Empreinte de Loup Gris',
      'date': 'Il y a 2 jours',
      'location': 'Forêt de Fontainebleau',
      'image': 'https://images.unsplash.com/photo-1586180418055-27664f9c61c6?q=80&w=2670&auto=format&fit=crop',
    },
    {
      'type': 'bookmark',
      'title': 'Ajout aux favoris: Renard Roux',
      'date': 'Il y a 5 jours',
      'image': 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?q=80&w=2672&auto=format&fit=crop',
    },
    {
      'type': 'explore',
      'title': 'Écosystème exploré: Savane Africaine',
      'date': 'Il y a 1 semaine',
      'image': 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?q=80&w=2371&auto=format&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Add haptic feedback for a more immersive experience
    HapticFeedback.lightImpact();
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
          
          // Main content
          SafeArea(
            child: CustomScrollView(
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
                
                // Activity history
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final activity = _activityHistory[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: _buildActivityItem(activity),
                      );
                    },
                    childCount: _activityHistory.length,
                  ),
                ),
                
                // Badges section
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
            child: Image.network(
              _userData['avatar'],
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // User name
        Text(
          _userData['name'],
          style: AppTextStyles.displayMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // User email
        Text(
          _userData['email'],
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        
        // Member since
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.quaternary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppRadius.circular),
          ),
          child: Text(
            "Membre depuis ${_userData['memberSince']}",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.quaternary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Bio
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            _userData['bio'],
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ),
        
        // Edit profile button
        FuturisticUI.techButton(
          label: "MODIFIER LE PROFIL",
          onPressed: () {
            // Edit profile
          },
          icon: Icons.edit,
          color: AppColors.accent,
        ),
      ],
    );
  }
  
  // Stats summary grid
  Widget _buildStatsSummary() {
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
                _userData['totalScans'].toString(), 
                "Scans", 
                Icons.camera_alt
              ),
              _buildStatItem(
                _userData['animalsIdentified'].toString(), 
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
    // Mock badges
    final badges = [
      {'name': 'Explorateur débutant', 'icon': Icons.adjust, 'color': AppColors.quaternary, 'unlocked': true},
      {'name': 'Traqueur de loups', 'icon': Icons.pets, 'color': AppColors.accent, 'unlocked': true},
      {'name': 'Photographe animalier', 'icon': Icons.camera, 'color': AppColors.secondary, 'unlocked': true},
      {'name': 'Maître de la forêt', 'icon': Icons.forest, 'color': AppColors.success, 'unlocked': false},
      {'name': 'Expert en empreintes', 'icon': Icons.fingerprint, 'color': AppColors.tertiary, 'unlocked': false},
      {'name': 'Ami des animaux', 'icon': Icons.favorite, 'color': AppColors.error, 'unlocked': false},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _buildBadgeItem(badge);
      },
    );
  }
  
  // Badge item
  Widget _buildBadgeItem(Map<String, dynamic> badge) {
    final bool unlocked = badge['unlocked'] as bool;
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: unlocked 
                ? badge['color'].withOpacity(0.2) 
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked 
                  ? badge['color'] as Color
                  : Colors.grey.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: unlocked
                ? [
                    BoxShadow(
                      color: (badge['color'] as Color).withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            badge['icon'] as IconData,
            color: unlocked
                ? badge['color'] as Color
                : Colors.grey.withOpacity(0.5),
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          badge['name'] as String,
          style: AppTextStyles.caption.copyWith(
            color: unlocked
                ? Colors.white
                : Colors.grey.withOpacity(0.7),
            fontWeight: unlocked
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        if (!unlocked)
          Text(
            "Verrouillé",
            style: AppTextStyles.caption.copyWith(
              color: Colors.grey.withOpacity(0.5),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
} 