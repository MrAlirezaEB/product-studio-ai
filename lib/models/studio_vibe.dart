class StudioVibe {
  final String id;
  final String name;
  final String description;
  final String prompt;
  final String emoji;

  const StudioVibe({
    required this.id,
    required this.name,
    required this.description,
    required this.prompt,
    required this.emoji,
  });

  static const List<StudioVibe> allVibes = [
    StudioVibe(
      id: 'minimalist_white',
      name: 'Minimalist White',
      description: 'Clean white background with soft shadows',
      prompt: 'professional minimalist white studio setting with soft lighting and subtle shadows, high-quality 4k resolution',
      emoji: '⚪',
    ),
    StudioVibe(
      id: 'luxury_dark',
      name: 'Luxury Dark',
      description: 'Elegant dark background with dramatic lighting',
      prompt: 'luxury dark studio setting with dramatic lighting and premium atmosphere, high-quality 4k resolution',
      emoji: '⬛',
    ),
    StudioVibe(
      id: 'nature_outdoor',
      name: 'Nature/Outdoor',
      description: 'Natural outdoor setting with organic elements',
      prompt: 'natural outdoor studio setting with organic elements and soft natural lighting, high-quality 4k resolution',
      emoji: '🌿',
    ),
    StudioVibe(
      id: 'pastel_pop',
      name: 'Pastel Pop',
      description: 'Vibrant pastel colors with playful energy',
      prompt: 'playful pastel studio setting with soft colors and cheerful atmosphere, high-quality 4k resolution',
      emoji: '🎨',
    ),
  ];
}
