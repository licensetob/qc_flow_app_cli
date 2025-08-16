import 'qc_text_basic_operations.dart';
import 'qc_text_cleaning_operations.dart';
import 'qc_text_extraction_operations.dart';
import 'qc_regex_operations.dart';
import 'qc_encoding_operations.dart';
import 'qc_special_text_operations.dart';

/// 精易模块风格的文本处理工具类汇总
class QcTextUtils {
  static final QcTextBasicOperations basic = QcTextBasicOperationsImpl();
  static final QcTextCleaningOperations cleaning = QcTextCleaningOperationsImpl();
  static final QcTextExtractionOperations extraction = QcTextExtractionOperationsImpl();
  static final QcRegexOperations regex = QcRegexOperationsImpl();
  static final QcEncodingOperations encoding = QcEncodingOperationsImpl();
  static final QcSpecialTextOperations special = QcSpecialTextOperationsImpl();
}
