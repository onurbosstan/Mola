//
//  PrivacyViewModel.swift
//  Mola
//
//  Created by Onur Bostan on 24.10.2024.
//

import Foundation

class PrivacyViewModel {
    
    func getPrivacyPolicyText() -> String {
        let privacyPolicyText = """
            Biz, Şirket Adı olarak, veri sorumlusu sıfatıyla, hangi kişisel verilerin hangi amaçla işleneceği, işlenen verilerin kimlerle ve neden paylaşılabileceği, veri işleme yöntemimiz ve hukuki sebeplerimiz ile ilgili bu gizlilik ve kişisel verilerin korunması politikası ile; işlenen verilerinizle ilgili haklarınız hakkında sizleri bilgilendirmeyi amaçlamaktayız.
        """
        
        let privacyPolicyText2 = """
            Bizimle paylaştığınız kişisel verileriniz yalnızca sunduğumuz hizmetlerin gerekliliklerini en iyi şekilde yerine getirebilmek, bu hizmetlerin size en üst düzeyde erişilebilmesini ve kullanılabilmesini sağlamak, hizmetlerimizi ihtiyaçlarınıza uygun şekilde geliştirmek ve sizi yasal çerçeveler içinde daha geniş hizmet sağlayıcılarla buluşturmak amacıyla işlenecek ve güncellenecektir. Kişisel verileriniz, sözleşme ve hizmet süresi boyunca amaca uygun ve orantılı bir şekilde işlenecektir.
        """
        
        let privacyPolicyText3 = """
            KVKK'nın 11. maddesini başlatan herkes veri sorumlusuna başvurarak şu haklarını kullanabilir:

            Kişisel verilerin işlenip işlenmediğini öğrenmek,
            Kişisel veriler işlenmişse buna ilişkin bilgi talep etmek,
            Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenmek,
            Kişisel verilerin yurt içinde veya yurt dışında aktarıldığı üçüncü kişileri bilmek,
            Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini istemek,
            Kişisel verilerin silinmesini veya yok edilmesini istemek,
            Eksik ya da yanlış işlenen verilerin düzeltilmesi veya silinmesi halinde bu işlemlerin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini istemek,
            İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin aleyhine bir sonucun ortaya çıkmasına itiraz etmek,
            Kişisel verilerin hukuka aykırı işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etmek.
        """
        
        return privacyPolicyText + "\n\n" + privacyPolicyText2 + "\n\n" + privacyPolicyText3
    }
}
