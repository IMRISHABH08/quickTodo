import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quicktodo/common/utils.dart';
import 'package:quicktodo/db/db.dart';
import 'package:quicktodo/providers/providers.dart';
import 'package:quicktodo/screens/home/home.dart';
import 'package:quicktodo/styles/textstyles/text_styles.dart';
import 'package:quicktodo/widgets/buttons/buttons.dart';

class Login extends HookConsumerWidget {
  Login({Key? key}) : super(key: key);
  final _userKey = GlobalKey<FormState>();
  final userFocusNode = FocusNode();

  final db = DB();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _passwdFocus = FocusNode();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = ref.watch((textStyleProvider));

    final colors = ref.watch(colorsProvider);
    final loginProvider = ref.watch(loginStateProvider);
    final phoneNumberController = useTextEditingController();
    final passwdController = useTextEditingController();
    final isMounted = useIsMounted();
    useEffect(() {
      if (isMounted()) {
        Future.delayed(Duration.zero, () {});
      }
      return () {};
    }, const []);
    return Container(
      child: SafeArea(
        child: Scaffold(
            //backgroundColor: colors.background,

            body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.asset(
              //     'assets/icons/login.png',
              //     fit: BoxFit.cover,
              //     width: MediaQuery.of(context).size.width * 0.2,
              //     height: 40,
                
              //   ),
              // ),
               SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              Card(
                // color: Colors.indigo[400],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.login,
                            ),
                          ),
                          Text('Enter Your Login Credentials',
                              style: textStyle.openSansSemiBold
                                  .copyWith(color: colors.background))
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Form(
                          key: _userKey,
                          child: Column(
                            children: [
                              phoneNumberTextField(
                                  textStyle, _userKey, phoneNumberController,
                                  (value) {
                                FocusScope.of(context).unfocus();
                                _userKey.currentState!.validate();
                              }, _phoneNumberFocus, context),
                              const SizedBox(
                                height: 5,
                              ),
                              passwdTextField(
                                  textStyle, _userKey, passwdController,
                                  (value) {
                                FocusScope.of(context).unfocus();
                                _userKey.currentState!.validate();
                              }, _passwdFocus, context)
                            ],
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 40),
                        child: CustomizedButton(
                          isLoading: loginProvider.isLoading,
                          title: 'Login',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_userKey.currentState!.validate()) {
                              db.storeUserCredentials(
                                  phoneNumberController.text,
                                  passwdController.text);
                              Get.offAll(() => Home());
                            }
                          },
                          height: 46,
                          width: MediaQuery.of(context).size.width * 0.8,
                          textStyle: textStyle.openSansSemiBold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
        )),
      ),
    );
  }
}

Widget phoneNumberTextField(
    TextStyles textStyle,
    GlobalKey<FormState> key,
    TextEditingController controller,
    ValueChanged<String> onFieldSubmitted,
    FocusNode focusNode,
    BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: validatePhoneNumber,
          focusNode: focusNode,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              label: const Text('Phone Number'),
              prefixIcon: const Icon(Icons.smartphone)),
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
            key.currentState!.validate();
          },
        ),
      ],
    ),
  );
}

Widget passwdTextField(
    TextStyles textStyle,
    GlobalKey<FormState> key,
    TextEditingController controller,
    ValueChanged<String> onFieldSubmitted,
    FocusNode focusNode,
    BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          validator: validatePassword,
          obscureText: true,
          focusNode: focusNode,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              label: const Text('Password'),
              prefixIcon: const Icon(Icons.lock)),
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
            key.currentState!.validate();
          },
        ),
      ],
    ),
  );
}
