
import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';
import 'package:todo_app/Localization.dart';
import 'package:todo_app/data/AppPreferences.dart';
import 'package:todo_app/presentation/settings/SettingsBloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final _EMAIL_VALIDATION_REGEX = RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  SettingsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SettingsBloc();
    _bloc.setNeedUpdateListener(_needUpdateListener);
  }

  void _needUpdateListener() {
    setState(() { });
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: PreferencePage([
        PreferenceTitle(AppLocalizations.of(context).settingsGeneral),
        SwitchPreference(
          AppLocalizations.of(context).settingsDefaultLock,
          AppPreferences.KEY_DEFAULT_LOCK,
          defaultVal: false,
          onChange: () => _bloc.onDefaultLockChanged(context, _scaffoldKey.currentState),
        ),
        PreferenceTitle(AppLocalizations.of(context).settingsResetPassword),
        TextFieldPreference(
          AppLocalizations.of(context).settingsRecoveryEmail,
          AppPreferences.KEY_RECOVERY_EMAIL,
          keyboardType: TextInputType.emailAddress,
          validator: (s) {
            if (!_isEmail(s)) {
              return AppLocalizations.of(context).invalidEmail;
            }
            return null;
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FlatButton(
            child: Text(AppLocalizations.of(context).sendTempPassword),
            onPressed: () => _bloc.onSendTempPasswordClicked(context, _scaffoldKey.currentState),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: FlatButton(
            child: Text(AppLocalizations.of(context).settingsResetPassword),
            onPressed: () => _bloc.onResetPasswordClicked(context, _scaffoldKey.currentState),
          ),
        )
      ]),
    );
  }

  bool _isEmail(String s) {
    return _EMAIL_VALIDATION_REGEX.hasMatch(s);
  }
}