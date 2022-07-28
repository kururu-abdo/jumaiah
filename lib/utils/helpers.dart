 String   showStatsText(String status) {
     switch (status) {
       case  'ok':
         return 'غير مرهون';
         break;
         case 'cancel':
          return 'شركاء';

        case 'draft':
        return 'مرهون';
       default:
       return '[غير معروف]';
     }
   }