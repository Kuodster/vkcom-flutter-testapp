import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:syazanou/http/custom_dio_interceptor.dart';
import 'package:syazanou/modules/app/bloc/router/app_router_bloc.dart';
import 'package:syazanou/modules/app/service_locator.dart';
import 'package:syazanou/modules/auth/helpers/auth_helper.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';

part 'api_client.dart';

part 'api_exception.dart';
