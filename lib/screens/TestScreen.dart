import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cas'),
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FormExample(),
            ],
          ),
        ),
      ),
    );
  }
}

class FormExample extends StatefulWidget {
  const FormExample({super.key});

  @override
  State<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _NFCController = TextEditingController();
  final TextEditingController _DecisionController = TextEditingController();
  final TextEditingController examClinic = TextEditingController();
  final TextEditingController correctionExamClinic = TextEditingController();
  final TextEditingController inlayCore = TextEditingController();
  final TextEditingController essayageInlayCore = TextEditingController();
  final TextEditingController scellementInlayCore = TextEditingController();
  final TextEditingController preparationDentsSupports =
      TextEditingController();
  final TextEditingController rectificationPreparations =
      TextEditingController();
  final TextEditingController empreinteGlobale = TextEditingController();
  final TextEditingController enregistrementOcclusion = TextEditingController();
  final TextEditingController detourage = TextEditingController();
  final TextEditingController essayageProthese = TextEditingController();
  final TextEditingController essayageArmatureMetallique =
      TextEditingController();
  final TextEditingController essayageCeramique = TextEditingController();
  final TextEditingController scellementDefinitif = TextEditingController();

  late int casenumber = 0;
  late int binomeId = 0;

  late bool caseResult = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    casenumber = arguments['casenumber'];
    binomeId = arguments['binomeId'];
    reload();
    _addData();
    Future.delayed(Duration(milliseconds: 500), () {
      _getData();
    });
  }

  Map<String, bool> checkStates = {
    "examClinic": false,
    "correctionExamClinic": false,
    "inlayCore": false,
    "essayageInlayCore": false,
    "scellementInlayCore": false,
    "preparationDentsSupports": false,
    "rectificationPreparations": false,
    "empreinteGlobale": false,
    "enregistrementOcclusion": false,
    "detourage": false,
    "essayageProthese": false,
    "essayageArmatureMetallique": false,
    "essayageCeramique": false,
    "scellementDefinitif": false,
  };

  Map<String, String> obsrStates = {
    "examClinic": "",
    "correctionExamClinic": "",
    "inlayCore": "",
    "essayageInlayCore": "",
    "scellementInlayCore": "",
    "preparationDentsSupports": "",
    "rectificationPreparations": "",
    "empreinteGlobale": "",
    "enregistrementOcclusion": "",
    "detourage": "",
    "essayageProthese": "",
    "essayageArmatureMetallique": "",
    "essayageCeramique": "",
    "scellementDefinitif": "",
  };

  final List<String> dataList = [
    'Examen clinique',
    'Correction de l’examen clinique',
    'L’empreinte directe de l’inlay core',
    'Essayage de l’inlay core',
    'Scellement de l’inlay core',
    'Préparation des dents supports',
    'Rectification des préparations',
    'Empreinte globale + empreinte antagoniste',
    'Enregistrement de l’occlusion + Montage sur articulateur',
    'Détourage + traçage de la ligne de finition',
    'Essayage de la prothèse métallique',
    'Essayage de l’armature métallique / Essayage de la chape en zircone + choix de la couleur',
    'Essayage de la céramique à l’état de biscuit / Essayage de la facette en résine',
    'Scellement définitif / Collage',
  ];

  Map<String, String> dateStates = {
    "examClinic": "",
    "correctionExamClinic": "",
    "inlayCore": "",
    "essayageInlayCore": "",
    "scellementInlayCore": "",
    "preparationDentsSupports": "",
    "rectificationPreparations": "",
    "empreinteGlobale": "",
    "enregistrementOcclusion": "",
    "detourage": "",
    "essayageProthese": "",
    "essayageArmatureMetallique": "",
    "essayageCeramique": "",
    "scellementDefinitif": "",
  };

  bool stringToBool(String str) {
    return str.toLowerCase() == 'true';
  }

  Future<List<List<dynamic>>> readData(String dest) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$dest.csv';
    final file = File(path);

    if (!await file.exists()) return [];

    final input = file.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();
    return fields;
  }

  Future<void> addData(List<dynamic> newData, String dest) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$dest.csv';
      final file = File(path);

      List<List<dynamic>> rows = [];
      int newId = 1;

      if (await file.exists()) {
        final input = file.openRead();
        rows = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter())
            .toList();

        if (rows.isNotEmpty) {
          final lastRow = rows.last;
          newId = int.tryParse(lastRow.first.toString())! + 1;
        }
      }

      newData.insert(0, newId.toString());
      rows.add(newData);

      String csvData = const ListToCsvConverter().convert(rows);
      await file.writeAsString(csvData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de l\'ajout: $e')),
      );
    }
  }

  Future<void> updateData(
      int rowIndex, List<dynamic> updatedData, String dest) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$dest.csv';
      final file = File(path);

      if (!await file.exists()) return;

      final input = file.openRead();
      List<List<dynamic>> rows = await input
          .transform(utf8.decoder)
          .transform(CsvToListConverter())
          .toList();

      if (rowIndex < rows.length) {
        final id = rows[rowIndex][0];
        updatedData.insert(0, id);

        rows[rowIndex] = updatedData;

        String csvData = const ListToCsvConverter().convert(rows);
        await file.writeAsString(csvData);
      }
    } catch (e) {
      print('An error occurred while updating the data: $e');
    }
  }

  Future<void> reload() async {
    bool cas1 = false;
    bool cas2 = false;
    List<List<dynamic>> casesData = await readData('Cases');
    for (var row in casesData) {
      if (row[4] == binomeId && row[5] == 1 && stringToBool(row[6])) {
        cas1 = true;
      } else if (row[4] == binomeId && row[5] == 2 && stringToBool(row[6])) {
        cas2 = true;
      }
    }
    List<List<dynamic>> studentsData = await readData('Students');
    int s = 0;
    for (var row in studentsData) {
      if (row[0] == binomeId) {
        List<dynamic> updatedData = [
          row[1],
          row[2],
          row[3],
          row[4],
          (cas1 && cas2).toString(),
          row[6],
          row[7],
        ];
        updateData(s, updatedData, 'Students');
        break;
      } else {
        s++;
      }
    }
  }

  Future<void> _addData() async {
    bool caseExists = false;
    List<List<dynamic>> casesData = await readData('Cases');
    for (var row in casesData) {
      if (row[5] == casenumber && row[4] == binomeId) {
        caseExists = true;
        break;
      }
    }

    if (!caseExists) {
      List<dynamic> newRow = ['', '', '', binomeId, casenumber, 'false'];
      await addData(newRow, 'Cases');
      for (int i = 0; i < dataList.length; i++) {
        List<dynamic> newTestRow = [
          dataList[i],
          'false',
          '',
          '',
          binomeId,
          casenumber
        ];
        await addData(newTestRow, 'Tests');
      }
    }
  }

  Future<void> _getData() async {
    List<List<dynamic>> casesData = await readData('Cases');
    for (var row in casesData) {
      if (row[5] == casenumber && row[4] == binomeId) {
        setState(() {
          caseResult = stringToBool(row[6]);
          _patientNameController.text = row[1].toString();
          _NFCController.text = row[2].toString();
          _DecisionController.text = row[3] ?? '';
        });
        break;
      }
    }

    List<List<dynamic>> testsData = await readData('Tests');
    int i = 0;
    for (var elt in checkStates.entries) {
      for (var row in testsData) {
        if (row[6] == casenumber &&
            row[5] == binomeId &&
            row[1] == dataList[i]) {
          setState(() {
            checkStates[elt.key] = stringToBool(row[2]);
            obsrStates[elt.key] = row[3] ?? '';
            dateStates[elt.key] = row[4] ?? '';
          });
          break;
        }
      }
      i++;
    }
  }

  Future<void> _changeData() async {
    List<dynamic> updatedRow = [
      _patientNameController.text,
      _NFCController.text,
      _DecisionController.text,
      binomeId,
      casenumber,
      checkStates["scellementDefinitif"].toString(),
    ];
    List<List<dynamic>> casesData = await readData('Cases');
    int i = 0;
    for (var row in casesData) {
      if (row[5] == casenumber && row[4] == binomeId) {
        await updateData(i, updatedRow, 'Cases');
        break;
      } else {
        i++;
      }
    }

    int j = 0;
    bool changed = false;
    List<List<dynamic>> testsData = await readData('Tests');
    for (var elt in checkStates.entries) {
      DateTime now = DateTime.now();
      String currentDate = '${now.day}-${now.month}-${now.year}';
      List<dynamic> updatedTestRow = [
        dataList[j],
        checkStates[elt.key].toString(),
        obsrStates[elt.key],
        currentDate,
        binomeId,
        casenumber,
      ];
      int k = 0;
      for (var row in testsData) {
        if (row[6] == casenumber &&
            row[5] == binomeId &&
            row[1] == dataList[j] &&
            (checkStates[elt.key].toString() != row[2] ||
                obsrStates[elt.key] != row[3])) {
          await updateData(k, updatedTestRow, 'Tests');
          changed = true;
          break;
        } else {
          k++;
        }
      }
      j++;
    }

    if (changed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Données Enregistrées')),
      );
      didChangeDependencies();
    }
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    List<List<dynamic>> studentsData = await readData('Students');
    String Student1 = "";
    String Student2 = "";
    String Student3 = "";
    int Grp = 0;
    int BiNum = 0;
    for (var row in studentsData) {
      if (row[0] == binomeId) {
        Student1 = row[1];
        Student2 = row[2] == 'null' ? "" : row[2];
        Student3 = row[3] == 'null' ? "" : row[3];
        Grp = row[4];
        BiNum = row[6];
      }
    }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Center(
              child: pw.Text(
                'Test',
                style:
                    pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Binome : ${Student1} ${Student2 == "" ? "" : ','} ${Student2} ${Student3 == "" ? "" : ','} ${Student3}  (B${BiNum}G${Grp})',
                style: pw.TextStyle(fontSize: 15),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Cas numéro : ${casenumber}',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Informations du patient :',
                style:
                    pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Padding(
              padding: pw.EdgeInsets.only(
                  left: 20), // add 20-point margin to the left
              child: pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'Nom et Prénom du patient : ${_patientNameController.text}',
                  style: pw.TextStyle(fontSize: 15),
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Padding(
              padding: pw.EdgeInsets.only(
                  left: 20), // add 20-point margin to the left
              child: pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'N°FC : ${_NFCController.text}',
                  style: pw.TextStyle(fontSize: 15),
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Padding(
              padding: pw.EdgeInsets.only(
                  left: 20), // add 20-point margin to the left
              child: pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  'Décision prothétique : ${_DecisionController.text}',
                  style: pw.TextStyle(fontSize: 15),
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Text(
                'Informations du test :',
                style:
                    pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FixedColumnWidth(150),
                1: pw.FixedColumnWidth(400),
                2: pw.FixedColumnWidth(280),
                3: pw.FixedColumnWidth(300),
              },
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Date'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Intervention'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Visa de L\'enseignant'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Observation'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${dateStates['examClinic'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Examen clinique'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['examClinic'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["examClinic"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${dateStates['correctionExamClinic'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Correction de l\'examen clinique'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['correctionExamClinic'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["correctionExamClinic"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${dateStates['inlayCore'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('L\'empreinte directe de l\'inlay core'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['inlayCore'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["inlayCore"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${dateStates['essayageInlayCore'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Essayage de l\'inlay core'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['essayageInlayCore'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["essayageInlayCore"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${dateStates['scellementInlayCore'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Scellement de l\'inlay core'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['scellementInlayCore'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["scellementInlayCore"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${dateStates['preparationDentsSupports'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Préparation des dents supports'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['preparationDentsSupports'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${obsrStates["preparationDentsSupports"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${dateStates['rectificationPreparations'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Rectification des préparations'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['rectificationPreparations'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${obsrStates["rectificationPreparations"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${dateStates['empreinteGlobale'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('Empreinte globale + empreinte antagoniste'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['empreinteGlobale'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["empreinteGlobale"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${dateStates['enregistrementOcclusion'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          'Enregistrement de l\'occlusion + Montage sur articulateur'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['enregistrementOcclusion'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${obsrStates["enregistrementOcclusion"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${dateStates['detourage'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          'Détourage + traçage de la ligne de finition'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['detourage'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["detourage"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${dateStates['essayageProthese'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Essayage de la prothèse métallique'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['essayageProthese'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["essayageProthese"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${dateStates['essayageArmatureMetallique'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          'Essayage de l\'armature métallique / Essayage de la chape en zircone + choix de la couleur'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['essayageArmatureMetallique'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${obsrStates["essayageArmatureMetallique"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${dateStates['essayageCeramique'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          'Essayage de la céramique à l\'état de biscuit / Essayage de la facette en résine'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['essayageCeramique'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["essayageCeramique"]}'),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child:
                          pw.Text('${dateStates['scellementDefinitif'] ?? ''}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('Scellement définitif / Collage'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text(
                          '${checkStates['scellementDefinitif'] == true ? 'Validé' : 'Not Validé'}'),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(2),
                      child: pw.Text('${obsrStates["scellementDefinitif"]}'),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            pw.Text(
              'Résultat du cas :  ${checkStates["scellementDefinitif"] == true ? 'Validé' : 'Not Validé'}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
          ],
        ),
      ),
    );

    var status = await Permission.storage.status;
    if (Platform.isAndroid) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      String pdfname = 'B${BiNum}G${Grp}C${casenumber}';
      String _selectedDirectory = "";

      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        setState(() {
          _selectedDirectory = directory;
        });
      }

      if (_selectedDirectory.isNotEmpty) {
        final path = "${_selectedDirectory}/${pdfname}.pdf";
        final file = File(path);

        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to: $path')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No directory selected')),
        );
      }
    } else {
      await Permission.storage.request();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      examClinic.text = obsrStates["examClinic"] ?? '';
      correctionExamClinic.text = obsrStates["correctionExamClinic"] ?? '';
      inlayCore.text = obsrStates["inlayCore"] ?? '';
      essayageInlayCore.text = obsrStates["essayageInlayCore"] ?? '';
      scellementInlayCore.text = obsrStates["scellementInlayCore"] ?? '';
      preparationDentsSupports.text =
          obsrStates["preparationDentsSupports"] ?? '';
      ;
      rectificationPreparations.text =
          obsrStates["rectificationPreparations"] ?? '';
      ;
      empreinteGlobale.text = obsrStates["empreinteGlobale"] ?? '';
      enregistrementOcclusion.text =
          obsrStates["enregistrementOcclusion"] ?? '';
      ;
      detourage.text = obsrStates["detourage"] ?? '';
      essayageProthese.text = obsrStates["essayageProthese"] ?? '';
      essayageArmatureMetallique.text =
          obsrStates["essayageArmatureMetallique"] ?? '';
      ;
      essayageCeramique.text = obsrStates["essayageCeramique"] ?? '';
      scellementDefinitif.text = obsrStates["scellementDefinitif"] ?? '';
    });
    return Center(
      child: SizedBox(
        width: screenWidth * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cas numero : $casenumber',
                style: const TextStyle(
                  color: Color.fromARGB(255, 70, 100, 125),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Center(
                child: caseResult
                    ? const Text(
                        'Cas Validé',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      )
                    : Container(),
              ),
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(
                  hintText: 'Nom et Prénom du patient',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir !!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _NFCController,
                decoration: const InputDecoration(
                  hintText: 'N°FC',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir !!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _DecisionController,
                decoration: const InputDecoration(
                  hintText: 'Décision prothétique',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez remplir !!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Test',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (screenWidth > 1000)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(5),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(4),
                  },
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  children: [
                    TableRow(
                      children: [
                        _buildTableCell(
                          'Date',
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildTableCell(
                          'Intervention',
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildTableCell(
                          'Visa de L\'enseignant',
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildTableCell(
                          'Observation',
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _buildTableRow(
                      dateStates['examClinic'] ?? '',
                      'Examen clinique',
                      checkStates['examClinic'],
                      (value) => setState(
                          () => checkStates['examClinic'] = value ?? false),
                      examClinic,
                      (value) =>
                          setState(() => obsrStates['examClinic'] = value),
                    ),
                    _buildTableRow(
                      dateStates['correctionExamClinic'] ?? '',
                      'Correction de l’examen clinique',
                      checkStates['correctionExamClinic'],
                      (value) => setState(() =>
                          checkStates['correctionExamClinic'] = value ?? false),
                      correctionExamClinic,
                      (value) => setState(
                          () => obsrStates['correctionExamClinic'] = value),
                    ),
                    _buildTableRow(
                      dateStates['inlayCore'] ?? '',
                      'L’empreinte directe de l’inlay core',
                      checkStates['inlayCore'],
                      (value) => setState(
                          () => checkStates['inlayCore'] = value ?? false),
                      inlayCore,
                      (value) =>
                          setState(() => obsrStates['inlayCore'] = value),
                    ),
                    _buildTableRow(
                      dateStates['essayageInlayCore'] ?? '',
                      'Essayage de l’inlay core',
                      checkStates['essayageInlayCore'],
                      (value) => setState(() =>
                          checkStates['essayageInlayCore'] = value ?? false),
                      essayageInlayCore,
                      (value) => setState(
                          () => obsrStates['essayageInlayCore'] = value),
                    ),
                    _buildTableRow(
                      dateStates['scellementInlayCore'] ?? '',
                      'Scellement de l’inlay core',
                      checkStates['scellementInlayCore'],
                      (value) => setState(() =>
                          checkStates['scellementInlayCore'] = value ?? false),
                      scellementInlayCore,
                      (value) => setState(
                          () => obsrStates['scellementInlayCore'] = value),
                    ),
                    _buildTableRow(
                      dateStates['preparationDentsSupports'] ?? '',
                      'Préparation des dents supports',
                      checkStates['preparationDentsSupports'],
                      (value) => setState(() =>
                          checkStates['preparationDentsSupports'] =
                              value ?? false),
                      preparationDentsSupports,
                      (value) => setState(
                          () => obsrStates['preparationDentsSupports'] = value),
                    ),
                    _buildTableRow(
                      dateStates['rectificationPreparations'] ?? '',
                      'Rectification des préparations',
                      checkStates['rectificationPreparations'],
                      (value) => setState(() =>
                          checkStates['rectificationPreparations'] =
                              value ?? false),
                      rectificationPreparations,
                      (value) => setState(() =>
                          obsrStates['rectificationPreparations'] = value),
                    ),
                    _buildTableRow(
                      dateStates['empreinteGlobale'] ?? '',
                      'Empreinte globale + empreinte antagoniste',
                      checkStates['empreinteGlobale'],
                      (value) => setState(() =>
                          checkStates['empreinteGlobale'] = value ?? false),
                      empreinteGlobale,
                      (value) => setState(
                          () => obsrStates['empreinteGlobale'] = value),
                    ),
                    _buildTableRow(
                      dateStates['enregistrementOcclusion'] ?? '',
                      'Enregistrement de l’occlusion + Montage sur articulateur',
                      checkStates['enregistrementOcclusion'],
                      (value) => setState(() =>
                          checkStates['enregistrementOcclusion'] =
                              value ?? false),
                      enregistrementOcclusion,
                      (value) => setState(
                          () => obsrStates['enregistrementOcclusion'] = value),
                    ),
                    _buildTableRow(
                      dateStates['detourage'] ?? '',
                      'Détourage + traçage de la ligne de finition',
                      checkStates['detourage'],
                      (value) => setState(
                          () => checkStates['detourage'] = value ?? false),
                      detourage,
                      (value) =>
                          setState(() => obsrStates['detourage'] = value),
                    ),
                    _buildTableRow(
                      dateStates['essayageProthese'] ?? '',
                      'Essayage de la prothèse métallique',
                      checkStates['essayageProthese'],
                      (value) => setState(() =>
                          checkStates['essayageProthese'] = value ?? false),
                      essayageProthese,
                      (value) => setState(
                          () => obsrStates['essayageProthese'] = value),
                    ),
                    _buildTableRow(
                      dateStates['essayageArmatureMetallique'] ?? '',
                      'Essayage de l’armature métallique/Essayage de la chape en zircone + choix de la couleur',
                      checkStates['essayageArmatureMetallique'],
                      (value) => setState(() =>
                          checkStates['essayageArmatureMetallique'] =
                              value ?? false),
                      essayageArmatureMetallique,
                      (value) => setState(() =>
                          obsrStates['essayageArmatureMetallique'] = value),
                    ),
                    _buildTableRow(
                      dateStates['essayageCeramique'] ?? '',
                      'Essayage de la céramique à l’état de biscuit/Essayage de la facette en résine',
                      checkStates['essayageCeramique'],
                      (value) => setState(() =>
                          checkStates['essayageCeramique'] = value ?? false),
                      essayageCeramique,
                      (value) => setState(
                          () => obsrStates['essayageCeramique'] = value),
                    ),
                    _buildTableRow(
                      dateStates['scellementDefinitif'] ?? '',
                      'Scellement définitif/Collage',
                      checkStates['scellementDefinitif'],
                      (value) => setState(() =>
                          checkStates['scellementDefinitif'] = value ?? false),
                      scellementDefinitif,
                      (value) => setState(
                          () => obsrStates['scellementDefinitif'] = value),
                    ),
                  ],
                ),
              if (screenWidth <= 1000)
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(6),
                  },
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                  children: [
                    _buildTestRow(
                      'Examen clinique',
                      checkStates['examClinic'],
                      (value) => setState(
                          () => checkStates['examClinic'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['examClinic'] ?? '',
                      examClinic,
                      (value) =>
                          setState(() => obsrStates['examClinic'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Correction de l’examen clinique',
                      checkStates['correctionExamClinic'],
                      (value) => setState(() =>
                          checkStates['correctionExamClinic'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['correctionExamClinic'] ?? '',
                      correctionExamClinic,
                      (value) => setState(
                          () => obsrStates['correctionExamClinic'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'L’empreinte directe de l’inlay core',
                      checkStates['inlayCore'],
                      (value) => setState(
                          () => checkStates['inlayCore'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['inlayCore'] ?? '',
                      inlayCore,
                      (value) =>
                          setState(() => obsrStates['inlayCore'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Essayage de l’inlay core',
                      checkStates['essayageInlayCore'],
                      (value) => setState(() =>
                          checkStates['essayageInlayCore'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['essayageInlayCore'] ?? '',
                      essayageInlayCore,
                      (value) => setState(
                          () => obsrStates['essayageInlayCore'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Scellement de l’inlay core',
                      checkStates['scellementInlayCore'],
                      (value) => setState(() =>
                          checkStates['scellementInlayCore'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['scellementInlayCore'] ?? '',
                      scellementInlayCore,
                      (value) => setState(
                          () => obsrStates['scellementInlayCore'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Préparation des dents supports',
                      checkStates['preparationDentsSupports'],
                      (value) => setState(() =>
                          checkStates['preparationDentsSupports'] =
                              value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['preparationDentsSupports'] ?? '',
                      preparationDentsSupports,
                      (value) => setState(
                          () => obsrStates['preparationDentsSupports'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Rectification des préparations',
                      checkStates['rectificationPreparations'],
                      (value) => setState(() =>
                          checkStates['rectificationPreparations'] =
                              value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['rectificationPreparations'] ?? '',
                      rectificationPreparations,
                      (value) => setState(() =>
                          obsrStates['rectificationPreparations'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Empreinte globale + empreinte antagoniste',
                      checkStates['empreinteGlobale'],
                      (value) => setState(() =>
                          checkStates['empreinteGlobale'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['empreinteGlobale'] ?? '',
                      empreinteGlobale,
                      (value) => setState(
                          () => obsrStates['empreinteGlobale'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Enregistrement de l’occlusion + Montage sur articulateur',
                      checkStates['enregistrementOcclusion'],
                      (value) => setState(() =>
                          checkStates['enregistrementOcclusion'] =
                              value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['enregistrementOcclusion'] ?? '',
                      enregistrementOcclusion,
                      (value) => setState(
                          () => obsrStates['enregistrementOcclusion'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Détourage + traçage de la ligne de finition',
                      checkStates['detourage'],
                      (value) => setState(
                          () => checkStates['detourage'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['detourage'] ?? '',
                      detourage,
                      (value) =>
                          setState(() => obsrStates['detourage'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Essayage de la prothèse métallique',
                      checkStates['essayageProthese'],
                      (value) => setState(() =>
                          checkStates['essayageProthese'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['essayageProthese'] ?? '',
                      essayageProthese,
                      (value) => setState(
                          () => obsrStates['essayageProthese'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Essayage de l’armature métallique/Essayage de la chape en zircone + choix de la couleur',
                      checkStates['essayageArmatureMetallique'],
                      (value) => setState(() =>
                          checkStates['essayageArmatureMetallique'] =
                              value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['essayageArmatureMetallique'] ?? '',
                      essayageArmatureMetallique,
                      (value) => setState(() =>
                          obsrStates['essayageArmatureMetallique'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Essayage de la céramique à l’état de biscuit/Essayage de la facette en résine',
                      checkStates['essayageCeramique'],
                      (value) => setState(() =>
                          checkStates['essayageCeramique'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['essayageCeramique'] ?? '',
                      essayageCeramique,
                      (value) => setState(
                          () => obsrStates['essayageCeramique'] = value),
                    ),
                    _SpaceRow(),
                    _buildTestRow(
                      'Scellement définitif/Collage',
                      checkStates['scellementDefinitif'],
                      (value) => setState(() =>
                          checkStates['scellementDefinitif'] = value ?? false),
                    ),
                    _buildDateObsrRow(
                      dateStates['scellementDefinitif'] ?? '',
                      scellementDefinitif,
                      (value) => setState(
                          () => obsrStates['scellementDefinitif'] = value),
                    ),
                    _SpaceRow(),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 222, 223, 225),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                        ),
                        onPressed: _changeData,
                        child: const Text(
                          'Soumettre',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 48, 89, 139),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 222, 223, 225),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                        ),
                        onPressed: generatePDF,
                        child: const Text(
                          'PDF',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 48, 89, 139),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableCell _buildTableCell(String text, TextStyle style) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      String date,
      String label,
      bool? value,
      ValueChanged<bool?> onChanged,
      TextEditingController observationController,
      ValueChanged<String> obsrChange) {
    return TableRow(
      children: [
        _buildTableCell(
          date,
          const TextStyle(
            fontSize: 16,
          ),
        ),
        _buildTableCell(
          label,
          const TextStyle(
            fontSize: 16,
          ),
        ),
        Container(
          height: 45,
          child: Center(
            child: Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        TextFormField(
          onChanged: obsrChange,
          controller: observationController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: 'Observation',
            border: InputBorder.none,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez remplir !!';
            }
            return null;
          },
        ),
      ],
    );
  }

  TableRow _buildTestRow(
      String label, bool? value, ValueChanged<bool?> onChanged) {
    return TableRow(
      children: [
        Container(
          height: 40,
          child: Center(
            child: Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        _buildTableCell(
          label,
          const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  TableRow _buildDateObsrRow(
      String date,
      TextEditingController observationController,
      ValueChanged<String> obsrChange) {
    return TableRow(
      children: [
        _buildTableCell(
          date,
          const TextStyle(
            fontSize: 16,
          ),
        ),
        TextFormField(
          onChanged: obsrChange,
          controller: observationController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: 'Observation',
            border: InputBorder.none,
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez remplir !!';
            }
            return null;
          },
        ),
      ],
    );
  }

  TableRow _SpaceRow() {
    return TableRow(
      children: [
        Container(
          height: 5,
          color: Colors.grey,
        ),
        Container(
          height: 5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
