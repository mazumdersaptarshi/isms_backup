// first_page.dart

import 'package:flutter/material.dart';

import 'expantiontile.dart';
import 'flipcard.dart';
import 'format.dart';
import 'horizontal_section.dart';
import 'page_title.dart';
import 'vertical_section.dart';

class CoursePageType2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 100, right: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PageTitle(title: 'ビジネスの目標を設定する'),
              HorizontalSection(
                imagePath: 'assets/images/image1.png',
                isImageFirst: true,
                imageFlex: 5,
                contentFlex: 2,
                contentList: [
                  Text(
                    '''
現在ビジネスが直面しているのは、消費者へのリーチ、エンドツーエンドのカスタマー ジャーニーの測定、ユーザーのプライバシーの尊重など、これまで以上に複雑さを増した問題です。\n   
カスタマー ジャーニー全体を測定し、どのキャンペーンが収益を最大化できるかを判断するには、まずビジネス目標を明確に定義し、その目標に沿った測定戦略を策定する必要があります。
                          ''',
                    style: Format.description,
                  ),
                  Text(
                    'このモジュールでは、以下について学習します。',
                    style: Format.descriptionBold,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '''
 ・ ビジネス目標の 4 つのタイプ
 ・ 目標をビジネスにあてはめる
 ・ 現実的な成長目標を設定する
                    ''',
                    style: Format.description,
                  ),
                ],
              ),
              VerticalSection(
                header: '明確な目標が鍵となる',
                contentList: [
                  Text(
                    'ビジネス目標を達成するにあたって、目標とするものを明確に定義することで、どの戦略がビジネスの成長に寄与するか、どの戦略に改善の余地があるかを判断できるようになります。',
                    style: Format.description,
                  ),
                  Text(
                    '''
 1. ビジネスの財務目標と戦略的な目標を設定します。
 2. ビジネスの財務目標と戦略的な目標をマーケティング目標に落とし込みます。
 3. マーケティング目標を広告キャンペーンの目標に落とし込みます。
                    ''',
                    style: Format.description,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'これにより、ビジネスにとって特に重要な情報を測定できるようになります。それぞれについて説明していきます。',
                    style: Format.description,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '各カードをクリックすると、説明が表示されます。',
                    style: Format.descriptionBold,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      CustomFlipCard(
                        imagePath: 'assets/images/zaimu.png',
                        frontText: '財務目標',
                        backText:
                            '財務目標では、収益、利益率、ボリューム（販売数など）の増加を重視します。多くの大企業では、事業分野ごとに下位目標を設定しています.',
                      ),
                      SizedBox(width: 10),
                      CustomFlipCard(
                        imagePath: 'assets/images/senryaku.png',
                        frontText: '戦略的な目標',
                        backText: '戦略的な目標とは、財務目標を達成する方法の概要を示すものです.',
                      ),
                      SizedBox(width: 10),
                      CustomFlipCard(
                        imagePath: 'assets/images/marketing.png',
                        frontText: 'マーケティング目標',
                        backText:
                            'マーケティング目標はビジネス目標の達成を支援するものです。小規模な企業では、このレベルの具体性を設定できない場合があります.',
                      ),
                      SizedBox(width: 10),
                      CustomFlipCard(
                        imagePath: 'assets/images/koukoku.png',
                        frontText: '広告キャンペーンの目標',
                        backText:
                            'マーケティング目標の達成に必要な、チャネルごとの目標を指します（YouTube キャンペーンの目標など）。\n\nキャンペーン指標: キャンペーン目標の成否を判断するために使用する個別の指標です.',
                      ),
                    ],
                  ),
                ],
              ),
              HorizontalSection(
                  isImageFirst: true,
                  imagePath: 'assets/images/image2.png',
                  imageFlex: 1,
                  contentFlex: 2,
                  contentList: [
                    Text(
                      'ビジネスへの適用',
                      style: Format.headline,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'パネルをクリックすると、説明が表示されます。',
                      style: Format.description,
                    ),
                    SizedBox(height: 10),
                    ExpansionTileCard(
                      closedTitle: 'ビジネスの目的を明文化する',
                      expandedTitle: 'ビジネスの目的を明文化する',
                      content: [
                        Text(
                          '''
まずは基本的なことを書き出しましょう。

 1. 会社名（ビジネスの名称）
 2. 商品やサービス
 3. 顧客
 4. 顧客に提供する成果やメリット

ご自身の会社にとって最適な短期的および長期的な目標は何ですか。次の質問への回答を考えてください。
 • 収益を生む仕組みはどのようなものですか？
 • 成長する可能性が高い分野は何ですか？
 • 市場で成功している競合他社と、その成功の理由は？
 • 今から 5 年後、ビジネスがどのような状況になっていることを望みますか？
                            ''',
                          style: Format.description,
                        ),
                      ],
                    ),
                  ]),
              HorizontalSection(
                  isImageFirst: false,
                  imagePath: 'assets/images/image3.png',
                  imageFlex: 1,
                  contentFlex: 2,
                  contentList: [
                    Text(
                      '財務目標: 収益を拡大する方法',
                      style: Format.headline,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '''
ビジネスを成功に導くには、収益を向上できるようにする必要があります。そのためには、経費を減らす、収益を増やすという 2 つの方法しかありません。収益を増やすには、価格を上げるかボリュームを増やす必要があります。ビジネスの種類に応じて、ボリュームは販売数、容量、見込み顧客数などを意味します。

短期目標と長期目標のバランスを取り、短期的な意思決定は、長期的な目標の達成にも寄与するものでなければなりません。

意思決定の影響がどのように波及するかを確認してみましょう。
                          ''',
                      style: Format.description,
                    ),
                  ]),
              HorizontalSection(
                  isImageFirst: true,
                  imagePath: 'assets/images/image2.png',
                  imageFlex: 1,
                  contentFlex: 2,
                  contentList: [
                    Text(
                      'ビジネスへの適用',
                      style: Format.headline,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'パネルをクリックすると、説明が表示されます。',
                      style: Format.description,
                    ),
                    SizedBox(height: 10),
                    ExpansionTileCard(
                      closedTitle: 'ビジネス戦略',
                      expandedTitle: 'ビジネス戦略',
                      content: [
                        Text(
                          '''
多くのビジネスでは財務について考える際、経費削減も非常に重要ではありますが、主に利益率、収益、ボリュームに重点が置かれます。あなたのビジネスにとって、どれが最適か考えてみましょう。

 • 利益率または利益の向上: 経費を削減して収益を増やすことを目指す企業に適しています。ただし、これにはトレードオフが伴います。たとえば、経費の削減を目的とした投資の中には、長期的に見れば収益性に貢献するものの、数年では回収できないために短期的に収益性を下げるものがあります。この手法は一般的に、すでに実績を築いている企業や、小売業など利益率の小さい企業に選択されます。
 • 収益の増加: 収益を増やすには、価格を据え置いて販売総数を増やすか、価格を上げるかのどちらかの手法が一般的です。つまり、売上の合計額が向上しなくても、収益は上がるということです。
 • ボリュームの増加: ボリュームを増やしたい場合は、価格を引き下げて販売数を増やすか、さまざまな戦術によって需要を喚起します。ただし、短期的には収益が下がる可能性があります。
                          ''',
                          style: Format.description,
                        ),
                      ],
                    ),
                  ]),
              HorizontalSection(
                isImageFirst: false,
                imagePath: 'assets/images/senryaku.png',
                imageFlex: 1,
                contentFlex: 2,
                contentList: [
                  Text(
                    '戦略的目標',
                    style: Format.headline,
                  ),
                  Text(
                    '''
財務目標に加えて、多くの企業は、戦略的目標も設定しています。戦略的目標は、財務目標を達成する方法の骨組みを表すものです。戦略的目標の例として、ブランド力の強化が挙げられます。
 
 • 「ブランド」という言葉を、ブランドのロゴと考える人もいますが、ここでは、人々が企業や商品に対して抱く印象、という意味で使用しています
 • ブランド力（ブランド エクイティ）とは、マーケティング業界で使用される言葉で、名前が有名であること（ソニーなど）の価値を意味します。ブランド名が広く知られていれば、ブランド認知度があるだけで多くの収益を生みだすことができます。

ユーザーがブランドを知らない場合、または好意的でない場合は、新規顧客の獲得は困難になり、既存の顧客を維持することも難しくなります。そのため、企業が長期にわたって売上を伸ばすには、ブランディングが非常に重要になります。
''',
                    style: Format.description,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
