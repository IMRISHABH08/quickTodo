import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicktodo/common/utils.dart';
import 'package:quicktodo/db/hive_adapter/todo_type_define.dart';
import 'package:quicktodo/providers/providers.dart';
import 'package:quicktodo/screens/home/home_state.dart';
import 'package:quicktodo/styles/color/colors_state.dart';
import 'package:quicktodo/styles/textstyles/text_styles.dart';
import 'package:quicktodo/widgets/appbars.dart';

class Home extends HookConsumerWidget {
  const Home({Key? key}) : super(key: key);
  final val = 1.0;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final _titleFocus = useFocusNode();
    final _descFocus = useFocusNode();
    final _key = GlobalKey<FormState>();
    final isMounted = useIsMounted();
    final colors = ref.watch(colorsProvider);
    final textStyles = ref.watch(textStyleProvider);
    final homeState = ref.watch(homeStateProvider);

    useEffect(() {
      if (isMounted()) {
        Future.delayed(const Duration(milliseconds: 0), () {
          ref.read(homeStateProvider.notifier).loadTodos();
        });
      }
      return () {};
    }, const []);
    return homeState.isLoading
        ? Container(
            color: colors.primary,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            //backgroundColor: colors.background.withOpacity(0.95),
            appBar: appBar(context, 'Quick ToDo',
                TextStyle(color: Colors.deepPurple[400])),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => ref
                        .read(homeStateProvider.notifier)
                        .view(!homeState.isGrid),
                    icon: Icon(
                      !homeState.isGrid
                          ? Icons.list_sharp
                          : Icons.grid_view_sharp,
                      color: colors.common,
                    )),
                Expanded(
                    child: homeState.isGrid
                        ? gridView(homeState, colors, textStyles, ref)
                        : listView(homeState, colors, textStyles, ref)),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _startAddNewTransaction(
                    val,
                    ref,
                    homeState,
                    colors,
                    textStyles,
                    context,
                    titleController,
                    descriptionController,
                    _key,
                    _titleFocus,
                    _descFocus);
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.deepPurple[400],
            ),
          );
  }

  Widget gridView(HomeState homeState, ColorsState colors,
      TextStyles textStyles, WidgetRef ref) {
    return GridView.count(
        crossAxisCount: 2,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        children: [
          ...homeState.list.map((e) {
            return Card(
              elevation: 5,
              //shadowColor: Colors.indigo,
              //color: Colors.redAccent,

              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(5),
                ),
              ),

              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 40),
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.indigo, Colors.redAccent]),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          e.desc,
                                          style: textStyles.openSansMedium,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          ref
                                              .read(homeStateProvider.notifier)
                                              .deleteTodos(
                                                  homeState.list.indexOf(e));
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.delete,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.only(
                          top: 7, bottom: 15, right: 7, left: 3),
                      //margin: EdgeInsets.only(top: 7,bottom: 10,right: 7),
                      child: Text(
                        e.title,
                        style: textStyles.openSansMedium.copyWith(
                            color: colors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )),
                  Positioned(
                    bottom: 20,
                    left: 5,
                    right: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Text(e.duration.toStringAsFixed(0) + ' Sec.',
                                      style: GoogleFonts.orbitron(
                                        textStyle: TextStyle(
                                            color: colors.primary,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                            ),
                            IconButton(
                                onPressed: () {
                                  ref
                                      .read(homeStateProvider.notifier)
                                      .handleTimer(!e.isPaused,
                                          homeState.list.indexOf(e));
                                },
                                icon: Icon(
                                  e.isPaused
                                      ? CupertinoIcons.play
                                      : CupertinoIcons.pause,
                                  size: 30,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              toDo(e, textStyles),
                              onGoing(e, textStyles),
                              done(e, textStyles),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ]);
  }

  Widget listView(HomeState homeState, ColorsState colors,
      TextStyles textStyles, WidgetRef ref) {
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                child: Container(
                    // height: 40,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                          colors: [Colors.indigo, Colors.redAccent]),
                    ),
                    //list-root-row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    homeState.list[index].title,
                                    style: textStyles.openSansMedium.copyWith(
                                        color: colors.primary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      ref
                                          .read(homeStateProvider.notifier)
                                          .todoEdit(
                                              index,
                                              !homeState.list[index].isOpen,
                                              true);
                                    },
                                    icon: Icon(
                                      homeState.list[index].isOpen
                                          ? CupertinoIcons.minus_circle
                                          : CupertinoIcons.plus_circle,
                                      size: 20,
                                    )),
                              ],
                            ),
                            //openClose Description
                            
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                 (homeState.list[index].isOpen)? homeState.list[index].desc:'OOPS!! NO DECRIPTION ADDED',
                                  style: textStyles.openSansRegular
                                      .copyWith(fontSize: 15),
                                ),
                              )
                              

                          ],
                        ),
                        //Delete--PlayPause-Timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                homeState.list[index].duration
                                        .toStringAsFixed(0) +
                                    ' Sec.',
                                style: GoogleFonts.orbitron(
                                  textStyle: TextStyle(
                                      color: colors.primary,
                                      letterSpacing: 3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  ref
                                      .read(homeStateProvider.notifier)
                                      .handleTimer(
                                          !homeState.list[index].isPaused,
                                          index);
                                },
                                icon: Icon(
                                  homeState.list[index].isPaused
                                      ? CupertinoIcons.play
                                      : CupertinoIcons.pause,
                                  size: 30,
                                )),
                            IconButton(
                                onPressed: () {
                                  ref
                                      .read(homeStateProvider.notifier)
                                      .deleteTodos(index);
                                },
                                icon: const Icon(
                                  CupertinoIcons.delete,
                                  size: 20,
                                ))
                          ],
                        ),
                      ],
                    )),
              ));
        },
        itemCount: homeState.list.length);
  }

  Widget toDo(Todo e, TextStyles textStyles) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: (e.status == 'TODO')
              ? BorderRadius.circular(15)
              : BorderRadius.circular(0),
          gradient: LinearGradient(colors: [
            (e.status == 'TODO') ? Colors.deepPurple : Colors.transparent,
            (e.status == 'TODO') ? Colors.redAccent : Colors.transparent
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'TODO',
            style: textStyles.openSansMedium.copyWith(
                fontSize: (e.status == 'TODO') ? 18 : 16,
                fontWeight:
                    (e.status == 'TODO') ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget onGoing(Todo e, TextStyles textStyles) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: (e.status == 'ON-GOING')
              ? BorderRadius.circular(15)
              : BorderRadius.circular(0),
          gradient: LinearGradient(colors: [
            (e.status == 'ON-GOING') ? Colors.deepPurple : Colors.transparent,
            (e.status == 'ON-GOING') ? Colors.redAccent : Colors.transparent
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'ON-GOING',
            style: textStyles.openSansMedium.copyWith(
                fontSize: (e.status == 'ON-GOING') ? 18 : 16,
                fontWeight: (e.status == 'ON-GOING')
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  Widget done(Todo e, TextStyles textStyles) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: (e.status == 'DONE')
              ? BorderRadius.circular(15)
              : BorderRadius.circular(0),
          gradient: LinearGradient(colors: [
            (e.status == 'DONE') ? Colors.deepPurple : Colors.transparent,
            (e.status == 'DONE') ? Colors.redAccent : Colors.transparent
          ]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'DONE',
            style: textStyles.openSansMedium.copyWith(
                fontSize: (e.status == 'DONE') ? 18 : 16,
                fontWeight:
                    (e.status == 'DONE') ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void _startAddNewTransaction(
      double valz,
      WidgetRef ref,
      HomeState state,
      ColorsState colors,
      TextStyles textstyles,
      BuildContext ctx,
      TextEditingController title,
      TextEditingController desc,
      GlobalKey<FormState> key,
      FocusNode _titleFocus,
      FocusNode _descFocus) {
    final FocusScopeNode _node = FocusScopeNode();
    double valz = 1;
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.0))),
      context: ctx,
      builder: (_) {
        return Padding(
          padding: MediaQuery.of(ctx).viewInsets,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
              },
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.3,
                  // color: Colors.redAccent,
                  child: Form(
                      key: key,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FocusScope(
                            node: _node,
                            child: textFields(
                                valz,
                                ref,
                                state,
                                colors,
                                textstyles,
                                ctx,
                                title,
                                desc,
                                key,
                                _titleFocus,
                                _descFocus,
                                _node)),
                      )),
                ),
              ),
              behavior: HitTestBehavior.opaque,
            );
          }),
        );
      },
    );
  }

  Widget textFields(
      double valz,
      WidgetRef ref,
      HomeState state,
      ColorsState colors,
      TextStyles textstyles,
      BuildContext ctx,
      TextEditingController title,
      TextEditingController desc,
      GlobalKey<FormState> key,
      FocusNode _titleFocus,
      FocusNode _descFocus,
      FocusScopeNode _node) {
    return Column(
      //reverse: true,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
          ],
          maxLength: 20,
          validator: validateTitle,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            filled: true,
            labelText: 'Title',
            labelStyle: TextStyle(color: colors.primary),
            errorStyle: TextStyle(color: colors.primary, fontSize: 12),
          ),
          controller: title,
          focusNode: _titleFocus,
          onEditingComplete: () {
            bool? validated = key.currentState?.validate();
            if (validated!) _node.nextFocus();
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(100),
          ],
          maxLength: 100,
          validator: validateDesc,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10)),
            filled: true,
            labelText: 'Description',
            labelStyle: TextStyle(color: colors.primary),
          ),
          controller: desc,
          focusNode: _descFocus,
          onEditingComplete: () {
            key.currentState?.validate();
            _node.nextFocus();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            slider(valz),
            TextButton.icon(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    ref
                        .read(homeStateProvider.notifier)
                        .addTodo(title.text, desc.text, valz);
                    Navigator.of(ctx).pop();
                    title.clear();
                    desc.clear();
                  }
                },
                icon: Icon(
                  Icons.add,
                  color: colors.primary,
                ),
                label: Text(
                  'ADD TODO',
                  style: textstyles.openSansMedium,
                ))
          ],
        )
      ],
    );
  }

  Widget slider(double valz) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Slider(
          value: valz,
          onChanged: (val) {
            setState(() {
              valz = val;
            });
          },
          min: 1,
          max: 600,
          divisions: 600,
          label: valz.toStringAsFixed(2),
        );
      },
    );
  }
}
