import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/activity_model.dart';
import '../../../providers/city_provider.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;
  const ActivityForm({super.key, required this.cityName});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Activity newActivity;
  final double _formPadding = 20.0;
  final double _fieldSpacing = 15.0;
  late bool _isLoading = false;

  @override
  void initState() {
    newActivity = Activity(
      city: widget.cityName,
      name: null,
      price: 0,
      image: null,
      status: ActivityStatus.ongoing,
    );
    super.initState();
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState?.save();

    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      setState(() => _isLoading = true);
      await cityProvider.addActivityToCity(newActivity);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Activité sauvegardée avec succès')),
      );

      if (mounted) Navigator.pop(context); // Fermer le dialogue
      if (mounted) Navigator.pop(context); // Fermer le formulaire
    } catch (e) {
      setState(()=>_isLoading=false);
      if (mounted) Navigator.pop(context); // Fermer le dialogue
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle activité à ${widget.cityName}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(_formPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Détails de l\'activité',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: _fieldSpacing * 2),

              // Champ Nom
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Nom de l\'activité',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Veuillez entrer un nom'
                            : null,
                onSaved: (value) => newActivity.name = value,
              ),
              SizedBox(height: _fieldSpacing),

              // Champ Prix
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: '€',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Veuillez entrer un prix';
                  if (double.tryParse(value!) == null) return 'Prix invalide';
                  return null;
                },
                onSaved: (value) => newActivity.price = double.parse(value!),
              ),
              SizedBox(height: _fieldSpacing),

              // Champ Image URL
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'URL de l\'image',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                validator:
                    (value) =>
                        value?.isEmpty ?? true
                            ? 'Veuillez entrer une URL'
                            : null,
                onSaved: (value) => newActivity.image = value,
              ),
              SizedBox(height: _fieldSpacing * 2),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: Text('ANNULER'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isLoading?null: submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: Text('SAUVEGARDER'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
