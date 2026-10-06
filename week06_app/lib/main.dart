import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WidgetDemoPage(),
    );
  }
}

/// 레이아웃 위젯별로 섹션을 나눠 보여주는 데모 페이지
class WidgetDemoPage extends StatelessWidget {
  const WidgetDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter 위젯 데모'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          DemoSection(
            title: '1. Container / Padding / Align / Center',
            description: '단일 자식을 꾸미고(Container), 여백을 주고(Padding), 위치를 잡는(Align, Center) 위젯',
            child: ContainerDemo(),
          ),
          DemoSection(
            title: '2. Row',
            description: '자식을 가로로 배치. mainAxisAlignment로 간격 조절',
            child: RowDemo(),
          ),
          DemoSection(
            title: '3. Column',
            description: '자식을 세로로 배치. 입력/선택 위젯을 세로로 나열',
            child: ColumnDemo(),
          ),
          DemoSection(
            title: '4. Expanded / Flexible / Spacer',
            description: 'Row/Column 안에서 남는 공간을 비율(flex)로 나눠 가짐',
            child: ExpandedDemo(),
          ),
          DemoSection(
            title: '5. Stack / Positioned',
            description: '자식을 겹쳐서 배치. Positioned로 위치 지정',
            child: StackDemo(),
          ),
          DemoSection(
            title: '6. Wrap',
            description: '공간이 부족하면 자동으로 줄바꿈',
            child: WrapDemo(),
          ),
          DemoSection(
            title: '7. ListView (가로 스크롤)',
            description: '스크롤 가능한 목록. scrollDirection으로 방향 지정',
            child: HorizontalListDemo(),
          ),
          DemoSection(
            title: '8. GridView',
            description: '격자 형태 배치. crossAxisCount로 열 개수 지정',
            child: GridDemo(),
          ),
          DemoSection(
            title: '9. Card / ListTile',
            description: '목록 항목에 자주 쓰이는 Material 위젯',
            child: CardListDemo(),
          ),
        ],
      ),
    );
  }
}

/// 섹션 제목 + 설명 + 데모 위젯을 감싸는 공통 위젯
class DemoSection extends StatelessWidget {
  const DemoSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description, style: textTheme.bodySmall),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// 1. Container / Padding / Align / Center
class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('Align: topLeft'),
            ),
          ),
          Center(child: Text('Center', style: TextStyle(fontSize: 20))),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Chip(label: Text('Padding 8')),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Row
class RowDemo extends StatelessWidget {
  const RowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.home, size: 32),
        const CircleAvatar(child: Text('A')),
        ElevatedButton(onPressed: () {}, child: const Text('Button')),
        IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
      ],
    );
  }
}

// 3. Column (상태가 있는 입력 위젯들)
class ColumnDemo extends StatefulWidget {
  const ColumnDemo({super.key});

  @override
  State<ColumnDemo> createState() => _ColumnDemoState();
}

class _ColumnDemoState extends State<ColumnDemo> {
  bool _switchValue = true;
  bool _checkValue = false;
  double _sliderValue = 0.4;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'TextField',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Switch'),
          value: _switchValue,
          onChanged: (v) => setState(() => _switchValue = v),
        ),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: _checkValue,
          onChanged: (v) => setState(() => _checkValue = v ?? false),
        ),
        Text('Slider: ${(_sliderValue * 100).round()}'),
        Slider(
          value: _sliderValue,
          onChanged: (v) => setState(() => _sliderValue = v),
        ),
        LinearProgressIndicator(value: _sliderValue),
      ],
    );
  }
}

// 4. Expanded / Flexible / Spacer
class ExpandedDemo extends StatelessWidget {
  const ExpandedDemo({super.key});

  Widget _box(String label, Color color) {
    return Container(
      height: 48,
      color: color,
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 1, child: _box('flex 1', Colors.red)),
            Expanded(flex: 2, child: _box('flex 2', Colors.green)),
            Expanded(flex: 3, child: _box('flex 3', Colors.blue)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Spacer →'),
            const Spacer(),
            FilledButton(onPressed: () {}, child: const Text('오른쪽 끝')),
          ],
        ),
      ],
    );
  }
}

// 5. Stack / Positioned
class StackDemo extends StatelessWidget {
  const StackDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.amber.shade200)),
          Positioned(
            left: 16,
            top: 16,
            child: Container(width: 80, height: 80, color: Colors.orange),
          ),
          Positioned(
            left: 56,
            top: 40,
            child: Container(width: 80, height: 80, color: Colors.teal),
          ),
          const Positioned(
            right: 12,
            bottom: 12,
            child: Badge(
              label: Text('3'),
              child: Icon(Icons.notifications, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

// 6. Wrap
class WrapDemo extends StatelessWidget {
  const WrapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const tags = [
      'Flutter', 'Dart', 'Widget', 'Layout', 'Row', 'Column',
      'Stack', 'Wrap', 'ListView', 'GridView',
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [for (final tag in tags) Chip(label: Text(tag))],
    );
  }
}

// 7. ListView (가로 스크롤)
class HorizontalListDemo extends StatelessWidget {
  const HorizontalListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.primaries[index % Colors.primaries.length].shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text('Item $index'),
          );
        },
      ),
    );
  }
}

// 8. GridView
class GridDemo extends StatelessWidget {
  const GridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.camera, Icons.music_note, Icons.map,
      Icons.mail, Icons.phone, Icons.settings,
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        for (final icon in icons)
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 36),
          ),
      ],
    );
  }
}

// 9. Card / ListTile
class CardListDemo extends StatelessWidget {
  const CardListDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final name in const ['홍길동', '김철수', '이영희'])
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(name[0])),
              title: Text(name),
              subtitle: const Text('ListTile subtitle'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name 선택됨')),
                );
              },
            ),
          ),
      ],
    );
  }
}
