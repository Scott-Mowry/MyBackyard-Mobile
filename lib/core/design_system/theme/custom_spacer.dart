import 'package:flutter/material.dart';

/// Padronização do espaçamento utilizado pelo Design System
///
/// Ao invés de utilizar configuração de [EdgeInsets] manualmente, é recomendado
/// utilizar o [CustomSpacer] para definir o [Padding].
///
///
/// {@tool snippet}
///
/// Define o espaçamento padrão para o lado direito.
///
/// ```dart
/// const CustomSpacer.left;
/// ```
///
/// {@end-tool}
///
/// {@tool snippet}
///
/// Define o espaçamento padrão para todos os lados.
///
/// ```dart
/// const CustomSpacer.all;
/// ```
///
/// {@end-tool}
///
/// {@tool snippet}
///
/// É possível compor os elementos de espaçamento com os operadores `+` e `*`
///
/// ```dart
/// CustomSpacer.horizontal.md + CustomSpacer.top.xs;
/// ```
/// {@end-tool}
///
/// Veja também:
/// * [CustomSpacerSide] Obter o [EdgeInsets] do [CustomSpacer] selecionado.
class CustomSpacer {
  const CustomSpacer._();

  static const double _minimumGridValue = 8.0;

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento do lado esquerdo
  ///
  /// ```dart
  /// const CustomSpacerSide.left
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get left => CustomSpacerSide(_minimumGridValue, _SidesFlag(1, 0, 0, 0));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento do lado superior
  ///
  /// ```dart
  /// const CustomSpacerSide.top
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get top => CustomSpacerSide(_minimumGridValue, _SidesFlag(0, 1, 0, 0));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento do lado direito
  ///
  /// ```dart
  /// const CustomSpacerSide.right
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get right => CustomSpacerSide(_minimumGridValue, _SidesFlag(0, 0, 1, 0));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento do lado inferior
  ///
  /// ```dart
  /// const CustomSpacerSide.bottom
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get bottom => CustomSpacerSide(_minimumGridValue, _SidesFlag(0, 0, 0, 1));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento de todos os lados
  ///
  /// ```dart
  /// const CustomSpacerSide.all
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get all => CustomSpacerSide(_minimumGridValue, _SidesFlag(1, 1, 1, 1));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento no eixo horizontal, definindo valores para o espaçamento à esquerda e direita do elemento.
  ///
  /// ```dart
  /// const CustomSpacerSide.horizontal
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get horizontal => CustomSpacerSide(_minimumGridValue, _SidesFlag(1, 0, 1, 0));

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento no eixo vertical, definindo valores para espaçamento do topo e da base do elemento.
  ///
  /// ```dart
  /// const CustomSpacerSide.vertical
  /// ```
  /// {@end-tool}
  static CustomSpacerSide get vertical => CustomSpacerSide(_minimumGridValue, _SidesFlag(0, 1, 0, 1));
}

/// Converte as denominações de espaçamento do design system em unidades
/// [EdgeInsets].
///
/// {@tool snippet}
///
/// Desta maneira se é desejado um espaçamento de 8, deve se utilizar o
/// equivalente a medida :
///
/// ```dart
/// CustomSpacerSide.xs
/// ```
///
/// Como o retorno é um objeto [EdgeInsets], é possível compor os espaçamento,
/// com os operadores `+`
///
/// ```dart
/// CustomSpacerSide.sd + CustomSpacerSide.sd
/// ```
///
/// {@end-tool}
class CustomSpacerSide {
  double spacer;
  _SidesFlag sidesFlag;

  CustomSpacerSide(this.spacer, this.sidesFlag);

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento extremamente pequeno dentro do design system.
  /// O valor do espaço é 0.0 (0.5x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.none
  /// ```
  /// {@end-tool}
  EdgeInsets get none {
    return EdgeInsets.zero;
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento extremamente pequeno dentro do design system.
  /// O valor do espaço é 4.0 (0.5x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xxs
  /// ```
  /// {@end-tool}
  EdgeInsets get xxs {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xxs);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento muito pequeno dentro do design system.
  /// O valor do espaço é 8.0 (1.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xs
  /// ```
  /// {@end-tool}
  EdgeInsets get xs {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xs);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento pequeno dentro do design system.
  /// O valor do espaço é 12.0 (1.5x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.sm
  /// ```
  /// {@end-tool}
  EdgeInsets get sm {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.sm);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento médio dentro do design system.
  /// O valor do espaço é 16.0 (2.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.md
  /// ```
  /// {@end-tool}
  EdgeInsets get md {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.md);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento médio dentro do design system.
  /// O valor do espaço é 24.0 (3.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xmd
  /// ```
  /// {@end-tool}
  EdgeInsets get xmd {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xmd);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento grande dentro do design system.
  /// O valor do espaço é 32.0 (4.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.lg
  /// ```
  /// {@end-tool}
  EdgeInsets get lg {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.lg);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento grande dentro do design system.
  /// O valor do espaço é 40.0 (5.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xlg
  /// ```
  /// {@end-tool}
  EdgeInsets get xlg {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xlg);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento muito grande dentro do design system.
  /// O valor do espaço é 64.0 (8.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xl
  /// ```
  /// {@end-tool}
  EdgeInsets get xl {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xl);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento muito grande dentro do design system.
  /// O valor do espaço é 128.0 (16.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xxl
  /// ```
  /// {@end-tool}
  EdgeInsets get xxl {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xxl);
  }

  ///
  /// {@tool snippet}
  ///
  /// Define o espaçamento extremamente grande dentro do design system.
  /// O valor do espaço é 256.0 (32.0x em relação ao valor padrão do grid)
  ///
  /// ```dart
  /// CustomSpacerSide.xxxl
  /// ```
  /// {@end-tool}
  EdgeInsets get xxxl {
    return _dimensionSize(spacer, sidesFlag, _FactorHelper.xxxl);
  }

  EdgeInsets _dimensionSize(double spacer, _SidesFlag sidesFlag, double factor) {
    return EdgeInsets.only(
      left: sidesFlag.leftFlag * spacer * factor,
      top: sidesFlag.topFlag * spacer * factor,
      right: sidesFlag.rightFlag * spacer * factor,
      bottom: sidesFlag.bottomFlag * spacer * factor,
    );
  }
}

class _SidesFlag {
  double leftFlag = 0;
  double topFlag = 0;
  double rightFlag = 0;
  double bottomFlag = 0;

  _SidesFlag(this.leftFlag, this.topFlag, this.rightFlag, this.bottomFlag);
}

// ignore: avoid_classes_with_only_static_members
class _FactorHelper {
  static double xxs = 0.5;
  static double xs = 1;
  static double sm = 1.5;
  static double md = 2;
  static double xmd = 3;
  static double lg = 4;
  static double xlg = 5;
  static double xl = 8;
  static double xxl = 16;
  static double xxxl = 32;
}
