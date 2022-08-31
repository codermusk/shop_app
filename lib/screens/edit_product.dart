import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';

class editProductScreen extends StatefulWidget {
  const editProductScreen({Key? key}) : super(key: key);
  static const route = '/edit_screen';

  @override
  State<editProductScreen> createState() => _editProductScreenState();
}

class _editProductScreenState extends State<editProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlcontroller = TextEditingController();
  final _imageNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedproduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _initvalues = {'title': '', 'description': '', 'price': '', 'image': ''};
  var _isloading = false;

  var isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    _imageNode.addListener(_updateImageurl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productid = ModalRoute.of(context)?.settings.arguments as String;
        _editedproduct =
            Provider.of<Products>(context, listen: false).findBy(productid);
        if (productid != null) {
          _initvalues = {
            'title': _editedproduct.title,
            'description': _editedproduct.description,
            'price': _editedproduct.price.toString(),
            'image': '',
          };
          _imageUrlcontroller.text = _editedproduct.imageUrl;
        }
      }
    }
    // TODO: implement didChangeDependencies
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _imageNode.removeListener(_updateImageurl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlcontroller.dispose();
    _imageNode.dispose();
    super.dispose();
  }

  void _updateImageurl() {
    if (!_imageNode.hasFocus) {
      if ((!_imageUrlcontroller.text.startsWith('http') &&
              !_imageUrlcontroller.text.startsWith('https')) ||
          (!_imageUrlcontroller.text.endsWith('png') &&
              !_imageUrlcontroller.text.endsWith('jpg') &&
              !_imageUrlcontroller.text.endsWith('jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final isValid = _form.currentState!.validate();
    setState(() {
      _isloading = true;
    });
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedproduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .UpdateProuct(_editedproduct.id.toString(), _editedproduct);
    } else {
      _form.currentState?.save();
      try {
        await Provider.of<Products>(context, listen: false)
            .addProductc(_editedproduct);
      } catch (error) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text('Some stuff went Wrong '),
                  title: Text('Error has been occured!!!'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
      }

      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD PRODUCTS'),
        actions: [IconButton(onPressed: saveForm, icon: Icon(Icons.save))],
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initvalues['title'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'PLEASE ENTER TITLE';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (newValue) => _editedproduct = Product(
                          id: _editedproduct.id,
                          title: newValue as String,
                          description: _editedproduct.description,
                          price: _editedproduct.price,
                          imageUrl: _editedproduct.imageUrl,
                          isFavourite: _editedproduct.isFavourite),
                    ),
                    TextFormField(
                      initialValue: _initvalues['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Add price ';
                        }
                        if (double.tryParse(value) == null) {
                          return 'ADD A VALID PRICE';
                        }
                        if (double.tryParse(value)! <= 0) {
                          return 'please Enter the Valid Price';
                        }
                        return null;
                      },
                      onSaved: (newValue) => _editedproduct = Product(
                          id: _editedproduct.id,
                          title: _editedproduct.title,
                          description: _editedproduct.description,
                          price: double.parse(newValue!),
                          imageUrl: _editedproduct.imageUrl,
                          isFavourite: _editedproduct.isFavourite),
                    ),
                    TextFormField(
                      initialValue: _initvalues['description'],
                      decoration: InputDecoration(labelText: 'DESCRIPTION'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionNode,
                      onSaved: (newValue) => _editedproduct = Product(
                          id: _editedproduct.id,
                          title: _editedproduct.title,
                          description: newValue as String,
                          price: _editedproduct.price,
                          imageUrl: _editedproduct.imageUrl,
                          isFavourite: _editedproduct.isFavourite),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter The Valid Description';
                        }
                        if (value.length <= 10) {
                          return 'Enter Quite Larger Description';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            )),
                            child: _imageUrlcontroller.text.isEmpty
                                ? Text('Enter The Url')
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child:
                                        Image.network(_imageUrlcontroller.text),
                                  )),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            validator: (value) {
                              if (!value!.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'please Enter Valid URl';
                              }
                              if (value.isEmpty) {
                                return 'PLEASE ENTER THE IMAGE URL';
                              }
                              if (!value.endsWith('jpeg') &&
                                  !value.endsWith('png') &&
                                  !value.endsWith(''
                                      'jpg')) {
                                return 'PLEASE ENTER THE  VALID IMAGE URL';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlcontroller,
                            focusNode: _imageNode,
                            onFieldSubmitted: (_) {
                              saveForm();
                            },
                            onSaved: (newValue) => _editedproduct = Product(
                                id: _editedproduct.id,
                                title: _editedproduct.title,
                                description: _editedproduct.description,
                                price: _editedproduct.price,
                                imageUrl: newValue as String,
                                isFavourite: _editedproduct.isFavourite),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
