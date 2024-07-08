import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:app_amic_dental_2024/services/doc_upload/doc_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

class DocumentItem extends StatefulWidget {
  DocumentItem(
      {super.key,
      required this.typeDocument,
      required this.base64File,
      required this.extensionDoc,
      required this.isFileExist,
      required this.clearSession});
  String base64File;
  String typeDocument;
  String extensionDoc;
  bool isFileExist;
  Function clearSession;

  State<DocumentItem> createState() => _DocumentItemState();
}

class _DocumentItemState extends State<DocumentItem> {
  List<String> _pictures = [];
  String extension = "";
  String checkIcon = "";
  Widget? dismissBackground;

  Future scanDocument() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (pictures == []) {
        EasyLoading.showError("Otorga permisos a la aplicacion");
        return;
      }

      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {}

    if (_pictures.isNotEmpty) {
      final pdf = pw.Document();
      for (String picturePath in _pictures) {
        final image = File(picturePath).readAsBytesSync();
        final imagePdf = pw.MemoryImage(image);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(imagePdf),
              );
            },
          ),
        );
      }

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/scanned_document.pdf');
      await file.writeAsBytes(await pdf.save());

      return file;
    }
  }

  openb64(b64File, formato) async {
    var filename = "mydoc";

    var bytes = base64Decode(b64File);
    final output = await getExternalStorageDirectory();
    File file = File("${output!.path}/$filename.$formato");
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  Future<bool> validateFileSize(File file) async {
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    if (fileSizeInMB <= 2) {
      return true;
    } else {
      return false;
    }
  }

  openScanner(BuildContext context) async {
    bool confirm = true;
    if (widget.isFileExist) {
      confirm = await onActionPressAlert(
          "¿Esta seguro de reemplazar el archivo en la nube?", "Reemplazar");
    }
    if (!confirm) {
      setState(() {});
      return;
    }
    File fileToUpload = await scanDocument();
    bool validateSize = await validateFileSize(fileToUpload);
    if (!validateSize) {
      EasyLoading.showInfo("El archivo es muy grande");
      return;
    }

    widget.extensionDoc = "pdf";
    widget.base64File = base64Encode(fileToUpload.readAsBytesSync());
    checkIcon = "upload";
    setState(() {});
    Provider.of<DocService>(context, listen: false).updateRequest = 1;
    var res = await Provider.of<DocService>(context, listen: false).uploadFile(
        base64Encode(fileToUpload.readAsBytesSync()),
        widget.typeDocument,
        "pdf");
    Provider.of<DocService>(context, listen: false).updateRequest = -1;
    if (res == null) {
      checkIcon = "error";

      setState(() {});
      return;
    }
    if (res.statusCode == 401) {
      EasyLoading.showInfo("Token Expirado");
      widget.clearSession();
    }
    widget.extensionDoc = "pdf";
    widget.base64File = base64Encode(fileToUpload.readAsBytesSync());

    res = jsonDecode(res.body);
    if (res["status"]) {
      checkIcon = "exist";
      widget.isFileExist = true;
    }
    res["status"] ? checkIcon = "exist" : checkIcon = "";
    setState(() {});
  }

  deleteFile(BuildContext context) async {
    bool confirm = await onActionPressAlert(
        "¿Esta seguro de eliminar el archivo en la nube?", "Eliminar");
    if (!confirm) {
      setState(() {});
      return;
    }
    widget.base64File = "";
    widget.isFileExist = false;

    checkIcon = "upload";
    setState(() {});
    Provider.of<DocService>(context, listen: false).updateRequest = 1;
    var res = await Provider.of<DocService>(context, listen: false)
        .uploadFile(widget.base64File, widget.typeDocument, "");
    Provider.of<DocService>(context, listen: false).updateRequest = -1;
    if (res == null) {
      checkIcon = "error";

      setState(() {});
      return;
    }
    if (res.statusCode == 401) {
      EasyLoading.showInfo("Token Expirado");
      widget.clearSession();
    }
    res = jsonDecode(res.body);
    !res["status"] ? checkIcon = "exist" : checkIcon = "";
    setState(() {});
  }

  Future<bool> onActionPressAlert(
      String message, String confirmTextButton) async {
    bool confirm = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar"),
          content: SingleChildScrollView(
            child: Column(children: [
              Text(message),
            ]),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                confirm = true;
                Navigator.of(context).pop();
              },
              child: Text(confirmTextButton),
            ),
          ],
        );
      },
    );
    return confirm;
  }

  pickLocalDocument(BuildContext context) async {
    bool confirm = true;
    if (widget.isFileExist) {
      confirm = await onActionPressAlert(
          "¿Esta seguro de reemplazar el archivo en la nube?", "Reemplazar");
    }
    if (!confirm) {
      setState(() {});
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          "pdf",
          "png",
          "jpeg",
        ]);

    if (result == null) return;
    PlatformFile resultFile = result.files.first;
    File file = File(resultFile.path!);
    bool validateSize = await validateFileSize(file);
    if (!validateSize) {
      EasyLoading.showInfo("El archivo es muy grande");
      return;
    }
    checkIcon = "upload";
    setState(() {});
    Provider.of<DocService>(context, listen: false).updateRequest = 1;
    var res = await Provider.of<DocService>(context, listen: false).uploadFile(
        base64Encode(file.readAsBytesSync()),
        widget.typeDocument,
        resultFile.extension!.toLowerCase());
    Provider.of<DocService>(context, listen: false).updateRequest = -1;
    if (res == null) {
      checkIcon = "error";
      setState(() {});
      return;
    }
    if (res.statusCode == 401) {
      EasyLoading.showInfo("Token Expirado");
      widget.clearSession();
    }
    widget.extensionDoc = resultFile.extension!.toLowerCase();
    widget.base64File = base64Encode(file.readAsBytesSync());
    res = jsonDecode(res.body);

    res["status"] ? checkIcon = "exist" : checkIcon = "";
    widget.isFileExist = res["status"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.base64File != "" || widget.isFileExist) checkIcon = "exist";
  }

  Widget changeIcon() {
    if (checkIcon == "exist") {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    if (checkIcon == "error") {
      return const Icon(
        Icons.close_outlined,
        color: Colors.red,
      );
    }

    if (checkIcon == "upload") {
      return Spin(
        spins: 5,
        infinite: true,
        key: UniqueKey(),
        duration: const Duration(seconds: 3),
        child: const Icon(
          Icons.sync_outlined,
          color: Colors.grey,
        ),
      );
    }

    return const Icon(
      Icons.error_outline,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: checkIcon == "exist"
          ? DismissDirection.horizontal
          : DismissDirection.startToEnd,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          deleteFile(context);
        } else {
          openScanner(context);
        }
      },
      secondaryBackground: dismissBackground = Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 10),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      background: dismissBackground = Container(
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(5),
        child: InkWell(
          child: ListTile(
            onTap: () async {
              if (widget.isFileExist && widget.base64File == "") {
                EasyLoading.show(
                    maskType: EasyLoadingMaskType.black, status: "Espere...");
                var objeto =
                    await Provider.of<DocService>(context, listen: false)
                        .getDocument(widget.typeDocument);
                if (objeto == null) return;
                widget.base64File = objeto["data"];
                widget.extensionDoc = objeto["type"];
              }
              EasyLoading.dismiss();
              if (widget.base64File != "" && widget.extensionDoc != "") {
                openb64(widget.base64File, widget.extensionDoc);
              }
            },
            leading: changeIcon(),
            title: Row(
              children: [
                Text(
                  widget.typeDocument,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () async {
                    pickLocalDocument(context);
                  },
                  icon: const Icon(
                    Icons.drive_folder_upload_outlined,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
