import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:uuid/uuid.dart';
import '../models/studio_vibe.dart';
import '../models/project.dart';
import '../providers/project_provider.dart';
import 'processing_screen.dart';

class ResultScreen extends ConsumerStatefulWidget {
  final File originalImage;
  final String generatedImageData;
  final StudioVibe selectedVibe;

  const ResultScreen({
    super.key,
    required this.originalImage,
    required this.generatedImageData,
    required this.selectedVibe,
  });

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  bool _showBefore = false;
  File? _generatedImageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveGeneratedImage();
  }

  Future<void> _saveGeneratedImage() async {
    try {
      final bytes = base64Decode(widget.generatedImageData);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${const Uuid().v4()}.jpg');
      await file.writeAsBytes(bytes);

      setState(() {
        _generatedImageFile = file;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveToGallery() async {
    if (_generatedImageFile == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final result = await ImageGallerySaver.saveFile(
        _generatedImageFile!.path,
      );

      if (mounted) {
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved to gallery!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Failed to save');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Future<void> _shareImage() async {
    if (_generatedImageFile == null) return;

    try {
      await Share.shareXFiles(
        [XFile(_generatedImageFile!.path)],
        text: 'Check out my AI-generated product photo!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _regenerate() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          imageFile: widget.originalImage,
          selectedVibe: widget.selectedVibe,
        ),
      ),
    );
  }

  void _saveProject() {
    if (_generatedImageFile == null) return;

    final project = Project(
      id: const Uuid().v4(),
      originalImagePath: widget.originalImage.path,
      generatedImagePath: _generatedImageFile!.path,
      vibeName: widget.selectedVibe.name,
      createdAt: DateTime.now(),
    );

    ref.read(projectProvider.notifier).addProject(project);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Project saved!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Studio Photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _generatedImageFile == null ? null : _saveProject,
          ),
        ],
      ),
      body: _generatedImageFile == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Before/After Toggle
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showBefore = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _showBefore
                                  ? const Color(0xFFFBD914)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Before',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _showBefore ? Colors.black : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _showBefore = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_showBefore
                                  ? const Color(0xFFFBD914)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'After',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: !_showBefore ? Colors.black : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Image Display
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Image.file(
                          _showBefore ? widget.originalImage : _generatedImageFile!,
                          key: ValueKey(_showBefore),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                // Action Buttons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _isSaving ? null : _saveToGallery,
                                icon: _isSaving
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.download),
                                label: const Text('Save'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _shareImage,
                                icon: const Icon(Icons.share),
                                label: const Text('Share'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _regenerate,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Regenerate'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFBD914),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
