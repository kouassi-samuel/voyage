import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/city_provider.dart';

class ActivityFormImagePicker extends StatefulWidget {
  final Function updateUrlField;
  const ActivityFormImagePicker({super.key, required this.updateUrlField});

  @override
  State<ActivityFormImagePicker> createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File? deviceImage;
  bool isUploading = false;

  Future<void> pickerImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? pickedFile = await imagePicker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          deviceImage = File(pickedFile.path);
          isUploading = true;
        });

        debugPrint("Image sélectionnée: ${pickedFile.path.split('/').last}");

        try {
          final imageUrl = await Provider.of<CityProvider>(
            context,
            listen: false,
          ).uploadImage(deviceImage!);

          debugPrint("URL finale de l'image: $imageUrl");
          widget.updateUrlField(imageUrl);

          if (mounted) {
            setState(() {
              isUploading = false;
            });
          }
        } catch (uploadError) {
          debugPrint("Erreur lors de l'upload: $uploadError");

          // En cas d'erreur, réinitialiser l'état
          if (mounted) {
            setState(() {
              isUploading = false;
              // Optionnel: réinitialiser l'image en cas d'erreur d'upload
              // deviceImage = null;
            });
          }

          // Afficher un message d'erreur à l'utilisateur
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur lors de l\'upload: $uploadError'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        debugPrint("Aucune image sélectionnée");
      }
    } catch (e) {
      debugPrint("Erreur lors de la sélection d'image: $e");

      if (mounted) {
        setState(() {
          isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text('Galerie'),
              onPressed: isUploading ? null : () => pickerImage(ImageSource.gallery),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_camera),
              label: const Text('Caméra'),
              onPressed: isUploading ? null : () => pickerImage(ImageSource.camera),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Indicateur de chargement pendant l'upload
        if (isUploading)
          const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Upload en cours...'),
              SizedBox(height: 10),
            ],
          ),

        // Affichage de l'image sélectionnée
        if (deviceImage != null)
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    deviceImage!,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                ),
                // Overlay pendant l'upload
                if (isUploading)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Aucune image\nsélectionnée',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }
}