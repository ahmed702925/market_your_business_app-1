import 'package:market_app/models/mydonation.dart';
import 'package:market_app/providers/mydonation_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class EditDonation extends StatefulWidget {
  static const routeName = '/edit_donation';
  final reqId;

  EditDonation({this.reqId});

  @override
  _EditDonationState createState() => _EditDonationState();
}

class _EditDonationState extends State<EditDonation> {
  String orgId = '';
  final _descFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isLoadImg = false;
  var _isInit = true;
  var _isLoading = true;
  File? _image;
  String? _downloadUrl;
  var _editedDonation = MyDonation(
    id: null,
    status: '',
    orgName: '',
    image: '',
    donationType: '',
    donationItems: '',
    donationDate: '',
    donationAmount: '',
    actName: '',
    userId: '',
    donatorName: '',
    donatorAddress: '',
    availableOn: '',
    donatorMobileNo: '',
  );
  var _initValues = {
    'status': '',
    'orgName': '',
    'image': '',
    'donationType': '',
    'donationItems': '',
    'donationDate': '',
    'donationAmount': '',
    'actName': '',
    'userId': '',
    'donatorName': '',
    'donatorAddress': '',
    'donatorMobile': '',
    'availableOn': '',
  };

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(img!.path);
      _isLoadImg = true;
    });

    Provider.of<MyDonationsProvider>(context, listen: false)
        .uploadImage(_image!)
        .then((val) {
      _downloadUrl = val;
      setState(() {
        _isLoadImg = false;
      });
      print("value from upload" + _downloadUrl!);
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    Provider.of<MyDonationsProvider>(context, listen: false)
        .deleteImage(_editedDonation.image);
    _form.currentState!.save();

    _editedDonation = MyDonation(
      id: _editedDonation.id,
      image: _downloadUrl != null ? _downloadUrl! : _editedDonation.image,
      orgName: _editedDonation.orgName,
      actName: _editedDonation.actName,
      donationAmount: _editedDonation.donationAmount,
      donationDate: _editedDonation.donationDate,
      donationItems: _editedDonation.donationItems,
      donationType: _editedDonation.donationType,
      status: _editedDonation.status,
      userId: _editedDonation.userId,
      donatorMobileNo: _editedDonation.donatorMobileNo,
      availableOn: _editedDonation.availableOn,
      donatorAddress: _editedDonation.donatorAddress,
      donatorName: _editedDonation.donatorName,
    );

    Provider.of<MyDonationsProvider>(context, listen: false)
        .updateMyDonation(_editedDonation.id!, _editedDonation);
    Provider.of<MyDonationsProvider>(context, listen: false)
        .updateDonationReq(_editedDonation, orgId);
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final reqId = widget.reqId;
      _editedDonation = Provider.of<MyDonationsProvider>(context, listen: false)
          .findById(reqId);
      MyDonation myDonation =
          Provider.of<MyDonationsProvider>(context, listen: false)
              .findById(_editedDonation.id!);
      setState(() {
        _isLoading = false;
      });
      Provider.of<MyDonationsProvider>(context, listen: false)
          .fetchAndSetOrg(myDonation.orgName)
          .then((value) => {
                orgId = value.id,
              });
      _initValues = {
        'status': _editedDonation.status,
        'orgName': _editedDonation.orgName,
        'image': _editedDonation.image,
        'donationType': _editedDonation.donationType,
        'donationItems': _editedDonation.donationItems,
        'donationDate': _editedDonation.donationDate,
        'donationAmount': _editedDonation.donationAmount,
        'actName': _editedDonation.actName,
        'donatorName': _editedDonation.donatorName,
        'donatorAddress': _editedDonation.donatorAddress,
        'donatorMobile': _editedDonation.donatorMobileNo,
        'availableOn': _editedDonation.availableOn,
      };
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل طلب الطلب'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(new FocusNode()),
                  child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(
                            _initValues['orgName']!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _initValues['actName']!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'اسم صاحب الطلب',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            textAlign: TextAlign.right,
                            initialValue: _initValues['donatorName'],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك أدخل أسم صاحب الطلب';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              print('from on save name = ' + value!);
                              _editedDonation = MyDonation(
                                donatorName: value,
                                actName: _editedDonation.actName,
                                id: _editedDonation.id,
                                status: _editedDonation.status,
                                donationType: _editedDonation.donationType,
                                donationItems: _editedDonation.donationItems,
                                donationDate: _editedDonation.donationDate,
                                donationAmount: _editedDonation.donationAmount,
                                orgName: _editedDonation.orgName,
                                image: _editedDonation.image,
                                userId: _editedDonation.userId,
                                availableOn: _editedDonation.availableOn,
                                donatorAddress: _editedDonation.donatorAddress,
                                donatorMobileNo:
                                    _editedDonation.donatorMobileNo,
                              );
                              print('from on save name after = ' +
                                  _editedDonation.donatorName);
                            },
                          ),
                          Text(
                            'عنوان صاحب الطلب',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            textAlign: TextAlign.right,
                            initialValue: _initValues['donatorAddress'],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك أدخل عنوان صاحب الطلب';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedDonation = MyDonation(
                                donatorAddress: value!,
                                donatorMobileNo:
                                    _editedDonation.donatorMobileNo,
                                availableOn: _editedDonation.availableOn,
                                userId: _editedDonation.userId,
                                donatorName: _editedDonation.donatorName,
                                actName: _editedDonation.actName,
                                id: _editedDonation.id,
                                status: _editedDonation.status,
                                donationType: _editedDonation.donationType,
                                donationItems: _editedDonation.donationItems,
                                donationDate: _editedDonation.donationDate,
                                donationAmount: _editedDonation.donationAmount,
                                orgName: _editedDonation.orgName,
                                image: _editedDonation.image,
                              );
                            },
                          ),
                          Text(
                            'رقم التليفون',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly // Allows only digits
                            ],
                            textAlign: TextAlign.right,
                            initialValue: _initValues['donatorMobile'],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك أدخل رقم التليفون';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedDonation = MyDonation(
                                donatorAddress: _editedDonation.donatorAddress,
                                donatorMobileNo: value!,
                                availableOn: _editedDonation.availableOn,
                                userId: _editedDonation.userId,
                                donatorName: _editedDonation.donatorName,
                                actName: _editedDonation.actName,
                                id: _editedDonation.id,
                                status: _editedDonation.status,
                                donationType: _editedDonation.donationType,
                                donationItems: _editedDonation.donationItems,
                                donationDate: _editedDonation.donationDate,
                                donationAmount: _editedDonation.donationAmount,
                                orgName: _editedDonation.orgName,
                                image: _editedDonation.image,
                              );
                            },
                          ),
                          Text(
                            'المواعيد المتاحه',
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            textAlign: TextAlign.right,
                            initialValue: _initValues['availableOn'],
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descFocusNode);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'من فضلك أدخل المواعيد المتاحه';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedDonation = MyDonation(
                                donatorAddress: _editedDonation.donatorAddress,
                                donatorMobileNo:
                                    _editedDonation.donatorMobileNo,
                                availableOn: value!,
                                userId: _editedDonation.userId,
                                donatorName: _editedDonation.donatorName,
                                actName: _editedDonation.actName,
                                id: _editedDonation.id,
                                status: _editedDonation.status,
                                donationType: _editedDonation.donationType,
                                donationItems: _editedDonation.donationItems,
                                donationDate: _editedDonation.donationDate,
                                donationAmount: _editedDonation.donationAmount,
                                orgName: _editedDonation.orgName,
                                image: _editedDonation.image,
                              );
                            },
                          ),
                          _initValues['donationType'] != 'عينى'
                              ? Text(
                                  'المبلغ',
                                  textAlign: TextAlign.center,
                                )
                              : Container(),
                          _initValues['donationType'] != 'عينى'
                              ? TextFormField(
                                  textAlign: TextAlign.right,
                                  initialValue: _initValues['donationAmount'],
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter
                                        .digitsOnly // Allows only digits
                                  ],
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_descFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'من فضلك أدخل المبلغ';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _editedDonation = MyDonation(
                                      actName: _editedDonation.actName,
                                      id: _editedDonation.id,
                                      status: _editedDonation.status,
                                      donationType:
                                          _editedDonation.donationType,
                                      donationItems:
                                          _editedDonation.donationItems,
                                      donationDate:
                                          _editedDonation.donationDate,
                                      donationAmount: value!,
                                      orgName: _editedDonation.orgName,
                                      image: _editedDonation.image,
                                      userId: _editedDonation.userId,
                                      availableOn: _editedDonation.availableOn,
                                      donatorAddress:
                                          _editedDonation.donatorAddress,
                                      donatorMobileNo:
                                          _editedDonation.donatorMobileNo,
                                      donatorName: _editedDonation.donatorName,
                                    );
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _initValues['donationType'] != 'نقدى'
                              ? Container(
                                  child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green, // Text color
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Text('اختيار صورة'),
                                  onPressed: () {
                                    getImage();
                                  },
                                ))
                              : Container(),
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: _isLoadImg
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : _initValues['donationType'] != 'نقدى'
                                    ? newImage()
                                    : Container(),
                          ),
                          Container(
                              padding: const EdgeInsets.all(5.0),
                              child: new ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green, // Text color
                                ),
                                child: Text('حفظ'),
                                onPressed: _saveForm,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget newImage() {
    return Center(
      child: Container(
        child: Column(
          children: <Widget>[
            _editedDonation.id != null && _image != null
                ? Image.file(
                    _image!,
                    height: MediaQuery.of(context).size.width / 2,
                  )
                : _editedDonation.id != null //update
                    ? Container(
                        height: MediaQuery.of(context).size.width / 2,
                        child: Image.network(_editedDonation.image))
                    : _image == null
                        ? Container()
                        : Image.file(
                            _image!,
                            height: MediaQuery.of(context).size.width / 2,
                          ),
          ],
        ),
      ),
    );
  }
}
