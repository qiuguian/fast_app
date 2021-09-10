part of fast_app_ui;

typedef FastPage<T>(BuildContext context, T viewModel);

abstract class FastState<T extends StatefulWidget> extends State<T> {
  // ignore: non_constant_identifier_names
  Widget FastAppPage<T extends FastViewModel>(
      {required T viewModel, required FastPage body}) {
    return new ScopedModel<T>(
      model: viewModel,
      child: new ScopedModelDescendant<T>(
        builder: (context, child, viewModel) {
          return body(context, viewModel);
        },
      ),
    );
  }
}
