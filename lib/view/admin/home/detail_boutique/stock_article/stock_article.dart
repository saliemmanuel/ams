import 'package:ams/view/admin/widget/article_card.dart';
import 'package:ams/view/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import '../../../widget/dialogue_ajout.dart';
import 'ajout_article/ajout_article.dart';

class StockArticle extends StatefulWidget {
  const StockArticle({super.key});

  @override
  State<StockArticle> createState() => _StockArticleState();
}

class _StockArticleState extends State<StockArticle> {
  String selectedItem = 'Disponible';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(data: "Stock"),
        actions: [
          IconButton.filled(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              dialogueAjout(child: const AjoutArticle(), context: context);
            },
          ),
          const SizedBox(width: 15.0),
          DropdownButton(
              hint: CustomText(data: selectedItem),
              items: const [
                DropdownMenuItem(
                  value: "Disponible",
                  child: CustomText(data: 'Disponible'),
                ),
                DropdownMenuItem(
                  value: "Epuiser",
                  child: CustomText(data: 'Epuiser'),
                ),
              ],
              onChanged: (v) {
                selectedItem = v!;
                setState(() {});
              }),
          const SizedBox(width: 15.0),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 32,
                itemBuilder: (context, index) {
                  return const ArticleCard();
                },
              ),
              const SizedBox(height: 300.0)
            ],
          ),
        ),
      ),
      bottomSheet: const SizedBox(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: CustomText(data: "Nombre produit: 31")),
              Expanded(
                  child: CustomText(
                      data: "Valeur stock: 392090 FCFA",
                      overflow: TextOverflow.visible)),
            ],
          ),
        ),
      ),
    );
  }
}
