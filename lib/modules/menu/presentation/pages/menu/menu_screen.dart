import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

class MenuScreen extends StatelessWidget {
  final int brandID;
  const MenuScreen({Key? key, required this.brandID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<MenusCubit>().fetchMenu(brandID);
    return BlocBuilder<MenusCubit, ResponseState>(
      builder: (context, state) {
        if (state is Success<MenusData>) {
          return MenuListView(sections: state.data.sections);
        } else if (state is Failed) {
          return Center(child: Text(state.failure.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _body(MenusData data){
    return ExpandedTileList.builder(
      itemCount: data.sections.length,
      maxOpened: 1,
      itemBuilder: (context, index, controller) {
        return ExpandedTile(
          theme: ExpandedTileThemeData(
            headerColor: controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
            headerRadius: AppSize.s16.rSp,
            headerPadding: EdgeInsets.all(0),
            headerSplashColor: Colors.white,
            contentBackgroundColor: Colors.blue,
            contentPadding: EdgeInsets.all(4.0),
            contentRadius: 12.0,
          ),
         // enabled: false,
          controller: controller,
          trailing: IconButton(icon:  Icon(Icons.arrow_forward_ios_rounded), onPressed: () {
            controller.toggle();
          },),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.sections[index].title),
              Switch(value: true, onChanged: (value){})
            ],
          ),
          content: Container(
            color: Colors.red,
            child: Column(
              children: [
                const Center(
                  child: Text(
                      "This is the content!ksdjfl kjsdflk sjdflksjdf lskjfd lsdkfj  ls kfjlsfkjsdlfkjsfldkjsdflkjsfdlksjdflskdjf lksdjflskfjlsfkjslfkjsldfkjslfkjsldfkjsflksjflskjflskfjlsfkjslfkjsflksjflskfjlsfkjslfkjslfkjslfkjslfkjsldfkjsdf"),
                ),
                MaterialButton(
                  onPressed: () {
                    controller.collapse();
                  },
                  child: Text("close it!"),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
