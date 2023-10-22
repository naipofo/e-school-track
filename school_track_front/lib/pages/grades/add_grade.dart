import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:school_track_front/gql_client.dart';
import 'package:school_track_front/graphql/generated/grades.req.gql.dart';

class AddGradeScreen extends StatelessWidget {
  const AddGradeScreen({super.key, this.cClass, this.user});

  final int? cClass;
  final int? user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Grade')),
        body: GqlFetch(
          operationRequest: GAddGradeDataReq(
            (b) => b.vars
              ..userid = user
              ..classid = cClass,
          ),
          builder: (context, data) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fakeInput('Class', data.Gclass?.group.name ?? ""),
                const SizedBox(height: 8),
                fakeInput('Student', data.user?.full_name ?? ""),
                const SizedBox(height: 8),
                AddGradeForm(
                  classId: cClass!,
                  studentId: user!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget fakeInput(String label, String value) {
  return TextField(
    readOnly: true,
    controller: TextEditingController.fromValue(
      TextEditingValue(
        text: value,
      ),
    ),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(label),
    ),
  );
}

class AddGradeForm extends StatefulWidget {
  const AddGradeForm({
    super.key,
    required this.classId,
    required this.studentId,
  });

  final int classId;
  final int studentId;

  @override
  State<AddGradeForm> createState() => _AddGradeFormState();
}

class _AddGradeFormState extends State<AddGradeForm> {
  final _formKey = GlobalKey<FormState>();
  final commentController = TextEditingController();
  final weightController = TextEditingController();

  int gradeValue = 1;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextField(
            controller: commentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Comment'),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Weight'),
            ),
          ),
          const SizedBox(height: 8),
          DropdownMenu(
            dropdownMenuEntries: const [
              DropdownMenuEntry(value: 1, label: '1'),
              DropdownMenuEntry(value: 2, label: '2'),
              DropdownMenuEntry(value: 3, label: '3'),
              DropdownMenuEntry(value: 4, label: '4'),
              DropdownMenuEntry(value: 5, label: '5'),
              DropdownMenuEntry(value: 6, label: '6'),
            ],
            label: const Text('value'),
            initialSelection: 1,
            onSelected: (value) => gradeValue = value ?? 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FilledButton(
              onPressed: () {
                context.pop();
                context
                    .read<ClientModel>()
                    .client
                    .request(
                      GAddGradeReq(
                        (g) => g.vars
                          ..class_id = widget.classId
                          ..student_id = widget.studentId
                          ..value = gradeValue
                          ..weight = int.parse(weightController.text)
                          ..comment = commentController.text.isNotEmpty
                              ? commentController.text
                              : null
                          ..teacher_id = 2,
                      ),
                    )
                    .listen((event) {});
              },
              child: const Text('add grade'),
            ),
          )
        ],
      ),
    );
  }
}
