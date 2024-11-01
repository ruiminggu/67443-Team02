import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let viewModel: EventViewModel
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack(spacing: 20) {
            Text("Share this QR Code")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .padding(.top)

            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.orange, lineWidth: 3)
                    .frame(width: 250, height: 250)
                
                Image(uiImage: generateQRCode(from: "EventID:12345"))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .padding(10)
            }

            HStack(spacing: 20) {
                Button(action: {
                    // Share functionality
                }) {
                    Text("Share")
                        .font(.system(size: 10))
                        .padding()
                        .frame(width: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                }
                .foregroundColor(.orange)
                
                Button(action: {
                    // Copy link functionality
                }) {
                    Text("Copy Link")
                        .font(.system(size: 10))
                        .padding()
                        .frame(width: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                }
                .foregroundColor(.orange)
                
                Button(action: {
                    // Download functionality
                }) {
                    Text("Download")
                        .font(.system(size: 10))
                        .padding()
                        .frame(width: 80)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.top)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6).ignoresSafeArea())
    }

    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(viewModel: EventViewModel())
    }
}
