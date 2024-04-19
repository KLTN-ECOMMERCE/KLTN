import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:store_app/api/api_product.dart';
import 'package:store_app/helper/keyboard.dart';
import 'package:store_app/utils/constants.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.productId,
  });
  final String productId;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  var _enteredComment = '';
  var _enteredRating = 1.0;
  var _isAuthenticating = false;
  bool _canReview = false;
  final _formKey = GlobalKey<FormState>();
  final ApiProduct _apiProduct = ApiProduct();

  void _canReviewProduct(String productId) async {
    try {
      final canReview = await _apiProduct.canUserReview(productId);
      if (canReview['canReview'].toString() == 'true') {
        setState(() {
          _canReview = true;
        });
      } else {
        setState(() {
          _canReview = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _sendReview(String productId) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    KeyboardUtil.hideKeyboard(context);
    try {
      setState(() {
        _isAuthenticating = true;
      });

      _canReviewProduct(productId);
      if (!_canReview) {
        throw Exception(
          'You must buy this product before review it !',
        );
      }
      final reviewResponse = await _apiProduct.reviewProduct(
        productId,
        _enteredComment,
        _enteredRating,
      );
      setState(() {
        _isAuthenticating = false;
      });
      if (!mounted) return;
      await showOkAlertDialog(
        context: context,
        title: reviewResponse['success'].toString() != 'true'
            ? 'FAILURE'
            : 'SUCCESS',
        message: reviewResponse['success'].toString() != 'true'
            ? 'Failed to send your review !'
            : 'Send your review successfully !',
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void initState() {
    _canReviewProduct(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    return _canReview
        ? LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                body: SafeArea(
                  child: SizedBox(
                    width: width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'What is your rate?',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Center(
                              child: RatingBar.builder(
                                itemCount: 5,
                                itemSize: 40,
                                initialRating: _enteredRating,
                                minRating: 1,
                                maxRating: 5,
                                itemPadding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                direction: Axis.horizontal,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (value) {
                                  _enteredRating = value;
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(8),
                              child: const Center(
                                child: Text(
                                  'Please share your opinion about the product',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    child: TextFormField(
                                      maxLength: 300,
                                      enableSuggestions: false,
                                      onTapOutside: (event) {
                                        KeyboardUtil.hideKeyboard(context);
                                      },
                                      maxLines: null,
                                      expands: true,
                                      onSaved: (newValue) =>
                                          _enteredComment = newValue!,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return kNullError;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: surfaceColor,
                                        hintText: 'Your review',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            _isAuthenticating
                                ? const CircularProgressIndicator()
                                : Container(
                                    margin: const EdgeInsets.all(25),
                                    height: 50,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      onPressed: () {
                                        _sendReview(widget.productId);
                                      },
                                      child: const Text(
                                        'SEND REVIEW',
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You cannot review this product',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }
}
