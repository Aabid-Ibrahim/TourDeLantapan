import 'package:app/utilities/constants.dart';
import 'package:app/widgets/icon_text.dart';
import 'package:app/widgets/image_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _currentIndex = 0;

  List<Barangay> barangays = [
    Barangay(
        name: "Bantuanon",
        photo: const AssetImage('assets/images/history.jpeg'),
        history:
            "History is narratives. From chaos comes order. We seek to understand the past by determining and ordering ‘facts’; and from these narratives we hope to explain the decisions and processes which shape our existence. Perhaps we might even distill patterns and lessons to guide – but never to determine – our responses to the challenges faced today. History is the study of people, actions, decisions, interactions and behaviours. It is so compelling a subject because it encapsulates themes which expose the human condition in all of its guises and that resonate throughout time: power, weakness, corruption, tragedy, triumph … Nowhere are these themes clearer than in political history, still the necessary core of the field and the most meaningful of the myriad approaches to the study of history. Yet political history has fallen out of fashion and subsequently into disrepute, wrongly demonised as stale and irrelevant. The result has been to significantly erode the utility of ordering, explaining and distilling lessons from the past. "),
    Barangay(
        name: "Kulasihan",
        photo: const AssetImage('assets/images/history.jpeg'),
        history:
            "History’s primary purpose is to stand at the centre of diverse, tolerant, intellectually rigorous debate about our existence: our political systems, leadership, society, economy and culture. However, open and free debate – as in so many areas of life – is too often lacking and it is not difficult to locate the cause of this intolerance. ˝"),
    Barangay(
        name: "Bugcaon",
        photo: const AssetImage('assets/images/history.jpeg'),
        history:
            "Writing history can be a powerful tool; it has shaped identities, particularly at the national level. Moreover, it grants those who control the narrative the ability to legitimise or discredit actions, events and individuals in the present. Yet to marshal history and send it into battle merely to serve the needs of the present is misuse and abuse. History should never be a weapon at the heart of culture wars. Sadly, once again, it is: clumsily wielded by those who deliberately seek to impose a clear ideological agenda. History is becoming the handmaiden of identity politics and self-flagellation. This only promotes poor, one-dimensional understandings of the past and continually diminishes the utility of the field. History stands at a crossroads; it must refuse to follow the trend of the times. "),
    Barangay(
        name: "Alanib",
        photo: const AssetImage('assets/images/history.jpeg'),
        history:
            "Any thoroughly researched and well-argued study of any aspect of the past counts, for me, as history. I do have a preference for historians who probe into the ‘why’ and the ‘how’ but, overall, I think that our scope should be as broad and as catholic as possible. I am old enough to remember a time when women’s history was a separate field – left, in many universities, to Women’s Studies programmes – and the existence of non-white people was recognised by historians only in the context of imperial history. Back then – I am talking only about the late 1980s – English, Anthropology and even History of Science departments were often more adventurous in addressing the history of ‘others’ but their work, we were often told by ‘real’ historians, wasn’t proper history: ‘they use novels as evidence, for heaven’s sake!’ ‘Have any of them been near an archive?’ ")
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBG1,
      child: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          CarouselSlider(
              items: List.generate(
                  barangays.length,
                  (index) => ImageCarousel(
                        borderRadius: 5,
                        bottomLabel: IconText(
                          label: barangays[index].name,
                          color: textColor2,
                          size: 16,
                          padding: const EdgeInsets.only(top: 10),
                          fontWeight: FontWeight.bold,
                        ),
                        assetImage: barangays[index].photo,
                        onPress: () {},
                      )),
              options: CarouselOptions(
                // viewportFraction: .1,
                enableInfiniteScroll: false,
                aspectRatio: 2,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                pageViewKey: const PageStorageKey<String>('carousel_slider'),
              )),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  key: ValueKey<int>(_currentIndex),
                  barangays[_currentIndex].history,
                  style: TextStyle(color: textColor2),
                )),
          )
        ],
      ),
    );
  }
}

class Barangay {
  Barangay({required this.name, required this.history, required this.photo});
  String name;
  AssetImage photo;
  String history;
}
