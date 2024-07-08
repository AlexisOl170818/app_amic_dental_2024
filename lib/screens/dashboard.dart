import 'package:animate_do/animate_do.dart';
import 'package:app_amic_dental_2024/models/item_option.dart';
import 'package:app_amic_dental_2024/screens/docs_carga.dart';
import 'package:app_amic_dental_2024/services/authentication_service.dart';
import 'package:app_amic_dental_2024/utils/utils.dart';
import 'package:app_amic_dental_2024/widgets/backdrop_customized.dart';
import 'package:app_amic_dental_2024/widgets/drawer_customized.dart';
import 'package:app_amic_dental_2024/widgets/option_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _advancedDrawerController = AdvancedDrawerController();
  List<ItemOption> listOptions = [];
  @override
  void initState() {
    listOptions = [];
    super.initState();
    getOptionsList();
  }

  final List<String> imgList = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZtzkXQwXYhzXO9hv725qw-SxkUsSfbWYAvyg8rOPKsg&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSr_C1S5yqu9fQ80vdnflLWZxNDLsFc3YV-q0HtafTedg&s',
    'https://www.amicdental.com.mx/admic/img/items/172752_slider_1.jpg',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  Future<bool> verifyUserAuth() async {
    return await AuthenticationService().verifyAuthUser();
  }

  getOptionsList() async {
    bool isAuth = await verifyUserAuth();
    List<ItemOption> listaOpciones = [
      ItemOption(
        icon: Icons.people,
        name: "Expositores",
        urlImage:
            "https://www.designcon.com/content/markets/na/designcon/en/exhibit/exhibitor-center/_jcr_content/root/content/content/responsivegrid/responsivegrid_888426617/grid/row0/col0/image.coreimg.100.1024.png/1697854626002/dc24-exhibitor-center-photo1.png",
        function: () =>
            Utils().launchUrl("https://www.amicdental.mx/expositores.php"),
        showItem: true,
      ),
      ItemOption(
          icon: Icons.map_outlined,
          name: "Mapa",
          urlImage: "https://cdn-icons-png.flaticon.com/512/3156/3156158.png",
          function: () => Utils().launchUrl(
                "https://www.amicdental.mx/plano.php",
              ),
          showItem: true),
      ItemOption(
          icon: Icons.mic_rounded,
          name: "Congresos",
          urlImage:
              "https://www.ev-eventos.com/wp-content/uploads/2016/10/congresos-ev-eventos.png",
          showItem: isAuth as bool),
      ItemOption(
        icon: Icons.calendar_month,
        name: "Actividades y Horarios",
        urlImage: "https://cdn-icons-png.flaticon.com/512/12451/12451411.png",
        function: () =>
            Utils().launchUrl("https://www.amicdental.mx/acerca-de.php"),
        showItem: true,
      ),
      ItemOption(
          icon: Icons.import_contacts,
          name: "Revista Amic",
          urlImage:
              "https://static.vecteezy.com/system/resources/previews/008/494/426/original/isolated-a4-opened-white-magazine-free-png.png",
          showItem: isAuth as bool),
      ItemOption(
          icon: Icons.play_circle,
          name: "Ver video diario",
          urlImage:
              "https://static.vecteezy.com/system/resources/previews/019/879/210/non_2x/video-camera-symbol-video-camera-icon-symbol-illustration-on-transparent-background-free-png.png",
          showItem: isAuth as bool),
      ItemOption(
          icon: Icons.upload_file,
          name: "Subir Archivos",
          function: () => Navigator.push(
              context, Utils().createTransition(const DocsCarga())),
          urlImage:
              "https://www.pngall.com/wp-content/uploads/2/Upload-PNG-Image-File.png",
          showItem: isAuth as bool),
    ];
    listOptions = listaOpciones.where((element) => element.showItem).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color color = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Theme.of(context).colorScheme.background
        : Colors.white;
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      backdropColor: Theme.of(context).colorScheme.onSecondary,
      backdrop: const BackdropCustomized(),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 200),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer:
          DrawerCustomized(advancedDrawerController: _advancedDrawerController),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "Bienvenido Alexis",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.arrow_back : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(16, 50, 114, 1),
                  Color.fromRGBO(223, 76, 18, 1)
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(16, 50, 114, 1),
                Color.fromRGBO(223, 76, 18, 1)
              ],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              CarouselSlider(
                items: imgList
                    .map((item) => Center(
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: FadeInImage(
                              placeholder: AssetImage('assets/noimage.gif'),
                              image: NetworkImage(item),
                              fit: BoxFit.fill,
                              height: 200,
                              width: double.infinity,
                              imageErrorBuilder:
                                  ((context, error, stackTrace) => const Image(
                                        image: AssetImage('assets/noimage.gif'),
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                      )),
                            ),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    enlargeCenterPage: true, height: 200, autoPlay: true),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: FadeInUp(
                  child: Container(
                    /*    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn, */
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.5,
                          crossAxisCount: 2,
                        ),
                        itemCount: listOptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return OptionItem(item: listOptions[index]);
                        }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
