// Teste de familiaridade (T8.2) - tela 1: FORMULARIO.
// Porte de apps/showcase/src/app/components/sg-group-box/samples/formulario.tsx.sample
// + sg-input-currency/samples/basico.tsx.sample (React), linha a linha.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

class FormularioScreen extends StatefulWidget {
  const FormularioScreen({super.key});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  // const { control, handleSubmit, watch } = useForm({ defaultValues: {...} });
  final form = SgFormController(
    defaultValues: {
      'name': '',
      'email': '',
      'phone': '',
      'cep': '',
      'password': '',
      'total': '0.00',
    },
  );
  Map<String, Object?>? submitted;

  void onSubmit(Map<String, Object?> data) => setState(() => submitted = data);

  @override
  Widget build(BuildContext context) {
    // const values = watch();
    // <form onSubmit={handleSubmit(onSubmit)}>
    return SingleChildScrollView(
      child: SgForm(
        controller: form,
        onValid: onSubmit,
        child: ListenableBuilder(
          listenable: form,
          builder: (context, _) => Column(
            children: [
              SgGroupBox(
                title: 'Formulário',
                child: SgGrid(
                  columns: {'base': 1, 'sm': 2},
                  gap: 16,
                  children: [
                    SgInputText(
                      id: 'name',
                      name: 'name',
                      control: form,
                      label: 'Nome completo',
                      required: true,
                    ),
                    SgInputEmail(
                      id: 'email',
                      name: 'email',
                      control: form,
                      label: 'Email',
                      required: true,
                    ),
                    SgInputPhone(
                      id: 'phone',
                      name: 'phone',
                      control: form,
                      label: 'Telefone',
                      required: true,
                    ),
                    SgInputPostalCode(
                      id: 'cep',
                      name: 'cep',
                      control: form,
                      label: 'CEP',
                      required: true,
                    ),
                    // <div className="sm:col-span-2">
                    SgPanel(
                      span: 2,
                      borderStyle: SgPanelBorderStyle.none,
                      children: [
                        SgInputPassword(
                          id: 'password',
                          name: 'password',
                          control: form,
                          label: 'Senha',
                          required: true,
                        ),
                      ],
                    ),
                    SgInputCurrency(
                      id: 'demo-basic',
                      label: 'Valor',
                      name: 'total',
                      control: form,
                      currency: 'BRL',
                    ),
                  ],
                ),
              ),
              SgButton(
                type: SgButtonType.submit,
                size: SgSize.sm,
                appearance: SgAppearance.outline,
                child: 'Enviar',
              ),
              Text('Valores: ${jsonEncode(form.getValues())}'),
              if (submitted != null) Text('Enviado: ${jsonEncode(submitted)}'),
            ],
          ),
        ),
      ),
    );
  }
}
