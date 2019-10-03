
import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/domain/entity/Category.dart';
import 'package:todo_app/domain/entity/DayRecord.dart';
import 'package:todo_app/domain/entity/ToDoRecord.dart';
import 'package:todo_app/presentation/day/DayBloc.dart';
import 'package:todo_app/presentation/day/DayState.dart';
import 'package:todo_app/presentation/widgets/DayMemoTextField.dart';
import 'package:todo_app/presentation/widgets/ToDoEditorTextField.dart';

class DayScreen extends StatefulWidget {
  final DayRecord dayRecord;

  DayScreen({
    Key key,
    this.dayRecord,
  }): super(key: key);

  @override
  State createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  DayBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DayBloc(widget.dayRecord);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: _bloc.getInitialState(),
      stream: _bloc.observeState(),
      builder: (context, snapshot) {
        return _buildUI(snapshot.data);
      }
    );
  }

  Widget _buildUI(DayState state) {
    return SafeArea(
      child: Material(
        child: Scaffold(
          floatingActionButton: state.stickyInputState == StickyInputState.HIDDEN ? FloatingActionButton(
            child: Image.asset('assets/ic_plus.png'),
            backgroundColor: AppColors.primary,
            splashColor: AppColors.primaryDark,
            onPressed: () => _bloc.onAddToDoClicked(),
          ) : null,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _buildHeader(state),
                  Expanded(
                    child: state.toDoRecords.length == 0 ? _buildEmptyToDosView(state) : _buildToDosView(state),
                  ),
                ],
              ),
              // 키보드 위 Sticky 입력창
              state.stickyInputState == StickyInputState.HIDDEN ? Container()
              : state.stickyInputState == StickyInputState.SHOWN_TODO ? _buildStickyEditorForToDo(state)
              : _buildStickyEditorForCategory(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(DayState state) {
    return Row(
      children: <Widget>[
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('assets/ic_back_arrow.png'),
          ),
          onTap: () => _bloc.onBackArrowClicked(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Text(
            state.title,
            style: TextStyle(
              fontSize: 24,
              color: AppColors.textBlack,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyToDosView(DayState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildDayMemo(state),
        Padding(
          padding: EdgeInsets.only(left: 18, top: 20),
          child: Text(
            'TODO',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textBlack,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '기록이 없습니다',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textBlackLight,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDayMemo(DayState state) {
    return Padding(
      padding: EdgeInsets.only(left: 6, top: 6, right: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'MEMO',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      child: Image.asset('assets/ic_collapse.png'),
                    ),
                    onTap: () => _bloc.onDayMemoCollapseOrExpandClicked(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: SizedBox(
                height: 93,
                child: DayMemoTextField(
                  text: state.memoText,
                  hintText: state.memoHint,
                  onChanged: (s) => _bloc.onDayMemoTextChanged(s),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToDosView(DayState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDayMemo(state),
          Padding(
            padding: EdgeInsets.only(left: 18, top: 20),
            child: Text(
              'TODO',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textBlack,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 76),
            child: Column(
              children: List.generate(state.toDoRecords.length, (index) {
                return _buildToDo(state.toDoRecords[index], index == state.toDoRecords.length - 1);
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToDo(ToDoRecord toDoRecord, bool isLast) {
    final toDo = toDoRecord.toDo;
    final category = toDoRecord.category;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
        ),
        InkWell(
          child: Dismissible(
            key: Key(toDo.key),
            direction: DismissDirection.endToStart,
            background: Container(
              color: AppColors.secondary,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, right: 21, bottom: 16),
                  child: Image.asset('assets/ic_trash.png'),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(width: 18,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _CategoryThumbnail(
                    category: category,
                    width: 36,
                    height: 36,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: 36),
                category.isNone ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    toDo.text,
                    style: toDo.isDone ? TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlackLight,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.textBlackLight,
                      decorationThickness: 2,
                    ) : TextStyle(
                      fontSize: 14,
                      color: AppColors.textBlack,
                    ),
                  ),
                ) : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        toDo.text,
                        style: toDo.isDone ? TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlackLight,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.textBlackLight,
                          decorationThickness: 2,
                        ) : TextStyle(
                          fontSize: 14,
                          color: AppColors.textBlack,
                        ),
                      ),
                      SizedBox(height: 2,),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textBlackLight,
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                toDo.isDone ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 19),
                  child: Image.asset('assets/ic_check.png'),
                ) : Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 14),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.textBlackLight,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                    ),
                    customBorder: CircleBorder(),
                    onTap: () => _bloc.onToDoCheckBoxClicked(toDo),
                  ),
                ),
              ],
            )
          ),
          onTap: () {},
        ),
        isLast ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
        ) : Container(),
      ],
    );
  }

  Widget _buildStickyEditorForToDo(DayState state) {
    final editingToDoRecord = state.editingToDoRecord;
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.divider, AppColors.divider.withAlpha(0)]
              )
            ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: AppColors.divider,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      child: _CategoryThumbnail(
                        category: editingToDoRecord?.category,
                        width: 24,
                        height: 24,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ToDoEditorTextField(
                          text: editingToDoRecord?.toDo != null ? editingToDoRecord.toDo.text : '',
                          hintText: editingToDoRecord == null ? '작업 추가' : '작업 수정',
                          onChanged: (s) => { },
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            editingToDoRecord == null ? '추가' : '수정',
                            style: TextStyle(
                              fontSize: 14,
                              color: state.toDoEditorText.length > 0 ? AppColors.primary : AppColors.textBlackLight,
                            ),
                          ),
                        ),
                        onTap: state.toDoEditorText.length > 0 ? () { } : null,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 10),
                  child: GestureDetector(
                    onTap: () { },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        color: AppColors.primary,
                      ),
                      child: Text(
                        '분류: ${editingToDoRecord?.category?.name ?? '없음'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStickyEditorForCategory(DayState state) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppColors.SCRIM,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 138,
                  child: ListView.builder(
                    itemCount: state.allCategories.length,
                    itemBuilder: (context, index) {
                      final category = state.allCategories[index];
                      return Column(
                        children: <Widget>[
                          index == 0 ? SizedBox(height: 4,) : Container(),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 8,),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: _CategoryThumbnail(
                                  category: category,
                                  width: 24,
                                  height: 24,
                                  fontSize: 14),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  category.displayName,
                                  style: TextStyle(
                                    color: AppColors.textBlack,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                              width: double.infinity,
                              height: 2,
                              color: AppColors.divider,
                            ),
                          ),
                          index == state.allCategories.length - 1 ? SizedBox(height: 4,) : Container(),
                        ],
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 2,
                  color: AppColors.DIVIDER_DARK,
                ),
                Column(
                  children: <Widget>[
                    _CategoryEditor(
                      category: state.editingCategory,
                      bloc: _bloc,
                    )
                  ],
                )
              ],
            ),
          )
        ),
      ],
    );
  }
}

class _CategoryEditor extends StatelessWidget {
  final Category category;
  final DayBloc bloc;

  _CategoryEditor({
    @required this.category,
    @required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _CategoryThumbnail(
          category: category,
          width: 24,
          height: 24,
          fontSize: 14
        ),
        Expanded(
          child: ToDoEditorTextField(
            text: category.name,
            onChanged: (s) => bloc.onEditingCategoryTextChanged(s),
          ),
        ),
        Text(
          '새로 생성',
          style: TextStyle(
            fontSize: 14,
            color: category.name.length > 0 ? AppColors.primary : AppColors.textBlackLight,
          ),
        ),
        Text(
          '수정',
          style: TextStyle(
            fontSize: 14,
            color: category.isNone ? AppColors.textBlackLight : AppColors.secondary,
          )
        ),
      ],
    );
  }
}

class _CategoryThumbnail extends StatelessWidget {
  final Category category;
  final double width;
  final double height;
  final double fontSize;

  _CategoryThumbnail({
    @required this.category,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final type = category.type;
    switch (type) {
      case CategoryType.IMAGE:
        return _ImageCategoryThumbnail(
          imagePath: category.imagePath,
          width: width,
          height: height
        );
      case CategoryType.BORDER:
        return _BorderCategoryThumbnail(
          color: category.borderColor,
          initial: category.initial,
          width: width,
          height: height,
          fontSize: fontSize,
        );
      case CategoryType.FILL:
        return _FillCategoryThumbnail(
          color: category.fillColor,
          initial: category.initial,
          width: width,
          height: height,
          fontSize: fontSize,
        );
      default:
        return _DefaultCategoryThumbnail(
          width: width,
          height: height,
        );
     }
  }
}

class _ImageCategoryThumbnail extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;

  _ImageCategoryThumbnail({
    @required this.imagePath,
    @required this.width,
    @required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height
    );
  }
}

class _BorderCategoryThumbnail extends StatelessWidget {
  final int color;
  final String initial;
  final double width;
  final double height;
  final double fontSize;

  _BorderCategoryThumbnail({
    @required this.color,
    @required this.initial,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(color),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textBlack,
          ),
        ),
      ),
    );
  }
}

class _FillCategoryThumbnail extends StatelessWidget {
  final int color;
  final String initial;
  final double width;
  final double height;
  final double fontSize;

  _FillCategoryThumbnail({
    @required this.color,
    @required this.initial,
    @required this.width,
    @required this.height,
    @required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(color),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.textWhite,
          ),
        ),
      ),
    );
  }
}

class _DefaultCategoryThumbnail extends StatelessWidget {
  final double width;
  final double height;

  _DefaultCategoryThumbnail({
    @required this.width,
    @required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundGrey,
      ),
    );
  }
}