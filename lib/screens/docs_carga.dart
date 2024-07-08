import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:app_amic_dental_2024/models/doc_upload/file_upload.dart';
import 'package:app_amic_dental_2024/services/doc_upload/doc_service.dart';
import 'package:app_amic_dental_2024/ui/input_decoration.dart';
import 'package:app_amic_dental_2024/widgets/card_container.dart';
import 'package:app_amic_dental_2024/widgets/document_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class DocsCarga extends StatefulWidget {
  const DocsCarga({super.key});

  @override
  State<DocsCarga> createState() => _DocsCarga();
}

class _DocsCarga extends State<DocsCarga> {
  List<FileUpload> ListType = [];
  String visitorName = "";
  String email = "";

  void showAlert(
      {required String title,
      required String message,
      required ToastificationType type}) {
    toastification.show(
        context: context,
        title: Text(title, style: const TextStyle(fontSize: 20)),
        description: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        style: ToastificationStyle.flatColored,
        type: type);
  }

  searchVisitor(idVisitor) async {
    FocusManager.instance.primaryFocus?.unfocus();
    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: "Espere...");
    var jsonResponse = await Provider.of<DocService>(context, listen: false)
        .searchVisitorData(idVisitor);
    EasyLoading.dismiss();
    if (jsonResponse == null) return;
    if (jsonResponse["status"]) {
      var data = jsonResponse["data"];
      List<FileUpload> lista = [];
      visitorName = data["Nombre"];
      email = data["Email"];
      List<dynamic> mapDocs = data["Docs"];
      mapDocs.forEach((element) {
        lista.add(FileUpload(
          name: element["name"],
          file: "",
          type: "",
          isFileExist: element["isFileExist"] ?? false,
        ));
      });
      ListType = lista;
      setState(() {});
    } else {
      var data = jsonResponse["data"];
      showAlert(title: "Error", message: data, type: ToastificationType.error);
    }
  }

  checkFinishedUpload(BuildContext context) {
    final res = Provider.of<DocService>(context, listen: false).countRequest;

    if (res > 0) {
      EasyLoading.showInfo(
          "Aun se estan subiendo algunos documentos, por favor espere...");
      return;
    }
    clearSession();
  }

  clearSession() async {
    Directory? folder = await getExternalStorageDirectory();
    if (folder != null) {
      List<FileSystemEntity> entities = folder.listSync(recursive: true);
      entities.forEach((entity) {
        if (entity.existsSync()) {
          if (entity is File) {
            entity.deleteSync();
          } else if (entity is Directory) {
            entity.deleteSync(recursive: true);
          }
        }
      });
    }
    ListType = [];
    visitorName = "";
    email = "";
    visitorController.text = "";

    setState(() {});
  }

  TextEditingController visitorController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          CardContainer(children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    controller: visitorController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autocorrect: false,
                    readOnly: visitorName != "",
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        prefixIcon: Icons.perm_identity_sharp,
                        hintText: "Ingresa el ID del visitante",
                        labelText: "Visitante",
                        color: Colors.orange),
                    validator: (value) {
                      String pattern = r'^(?=.*[1-9])\d+$';

                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : 'Debe ser mayor a 0 y no debe contener simbolos (, - .).';
                    },
                  ),
                  /* ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          visitorName == "") {
                        searchVisitor(visitorController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: visitorName == ""
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                        foregroundColor: Colors.white),
                    child: const Text("Buscar"),
                  ), */
                  MaterialButton(
                    onPressed: visitorName == ""
                        ? () {
                            if (formKey.currentState!.validate()) {
                              searchVisitor(visitorController.text);
                            }
                          }
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: visitorName == ""
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).disabledColor,
                    textColor: Colors.white,
                    disabledColor: Theme.of(context).disabledColor,
                    child: Container(
                      child: const Text(
                        "Buscar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
          const SizedBox(
            height: 10,
          ),
          ListType.isNotEmpty
              ? Container(
                  width: double.infinity,
                  child: CardContainer(children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nombre:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            visitorName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "Email:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Divider(),
          const Text(
            "Documentos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ListType.isNotEmpty
              ? Expanded(
                  key: UniqueKey(),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: ListType.length,
                      itemBuilder: (ctx, index) =>
                          AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: DocumentItem(
                              typeDocument: ListType[index].name,
                              base64File: ListType[index].file ?? "",
                              extensionDoc: ListType[index].type ?? "",
                              isFileExist: ListType[index].isFileExist,
                              clearSession: clearSession,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(
                  height: 1,
                ),
          ListType.isNotEmpty
              ? FadeInDown(
                  child: ElevatedButton(
                    onPressed: () {
                      checkFinishedUpload(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      minimumSize: const Size(200, 40),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Finalizar",
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      /* floatingActionButton: ListType.isNotEmpty
          ? FloatingActionButton(
              onPressed: () async {
                EasyLoading.show(
                    maskType: EasyLoadingMaskType.black, status: "Espere...");
                await Provider.of<DocService>(context, listen: false)
                    .uploadFiles();
                EasyLoading.dismiss();
              },
              child: const Icon(Icons.upload),
            )
          : null, */
    );
  }
}
